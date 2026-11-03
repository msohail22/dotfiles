-- Competitive programming: compile and run a problem's sample testcases.
-- `receive` needs the "competitive-companion" browser extension, which posts
-- the scraped problem to port 27121.
--
-- Testcases live beside the source: A.cpp -> A_input0.txt and A_output0.txt,
-- counting from 0. No input.txt/output.txt by hand, and no freopen in the
-- template: competitest feeds the testcase through stdin.

-- --- Archiving a solved problem ---------------------------------------------
-- Day to day the work happens in yo.cpp. <leader>cs files that buffer away
-- under ~/Github/cp-setup/solved/<judge>/ so nothing is copied by hand.
-- The folder is "solved", not "cf": Competitive Companion feeds this setup
-- from any judge, so a Codeforces-only name would be a lie.
--
-- The rule, by what is already on disk (judge Codeforces shown):
--
--   nothing yet        ->  solved/Codeforces/A-Watermelon.cpp
--   that file exists   ->  solved/Codeforces/A-Watermelon/solution-1.cpp (moved)
--                          solved/Codeforces/A-Watermelon/solution-2.cpp (this one)
--   that folder exists ->  solved/Codeforces/A-Watermelon/solution-N.cpp
--
-- So a second solution turns the file into a folder on its own, and every
-- later solution just lands in it.
local cp_root = vim.fn.expand('~/Github/cp-setup')
local solved_dir = cp_root .. '/solved'
local default_judge = 'Codeforces'

-- "A. Watermelon.cpp" -> "A-Watermelon". Keeps the problem letter, because it
-- sorts the folder in contest order, and drops everything a shell dislikes.
local function slugify(name)
  return (name
    :gsub('%.%w+$', '')        -- strip the extension
    :gsub('[^%w]+', '-')       -- anything not a letter or digit becomes a dash
    :gsub('^%-+', '')
    :gsub('%-+$', ''))
end

-- A received problem sits at cp-setup/<Judge>/<Contest>/A.cpp, so the judge is
-- the first path part under cp-setup. yo.cpp sits at the root and says nothing,
-- so that case falls back to default_judge and the prompt can be edited.
local function judge_of_buffer()
  local full = vim.fn.expand('%:p')
  local root = cp_root .. '/'
  local rest = full:sub(1, #root) == root and full:sub(#root + 1) or ''
  local first = rest:match('^([^/]+)/')
  return first or default_judge
end

local function archive_solution()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local current = vim.fn.expand('%:t')
  -- yo.cpp is the scratch pad, so its name says nothing about the problem.
  local name = (current == '' or current == 'yo.cpp') and '' or slugify(current)
  -- One prompt, not two: the judge is part of the answer and is pre-filled.
  local default = judge_of_buffer() .. '/' .. name

  vim.ui.input({ prompt = 'Judge/problem: ', default = default }, function(answer)
    if not answer or answer == '' then return end
    local judge, problem = answer:match('^(.-)/(.*)$')
    if not judge or judge == '' or problem == '' then
      vim.notify('Write it as Judge/problem, for example Codeforces/A-Watermelon', vim.log.levels.ERROR)
      return
    end
    local slug = slugify(problem)
    local judge_dir = solved_dir .. '/' .. slugify(judge)

    local single = judge_dir .. '/' .. slug .. '.cpp'
    local folder = judge_dir .. '/' .. slug
    local target

    -- Highest existing number plus one, never the count: deleting
    -- solution-2 out of three must not make the next save overwrite
    -- solution-3.
    local function next_solution()
      local highest = 0
      for _, path in ipairs(vim.fn.glob(folder .. '/solution-*.cpp', false, true)) do
        local n = tonumber(path:match('solution%-(%d+)%.cpp$'))
        if n and n > highest then highest = n end
      end
      return folder .. '/solution-' .. (highest + 1) .. '.cpp'
    end

    if vim.fn.isdirectory(folder) == 1 then
      target = next_solution()
    elseif vim.fn.filereadable(single) == 1 then
      vim.fn.mkdir(folder, 'p')
      -- rename() returns non-zero on failure (`:help rename()`). Stop rather
      -- than leave the old solution stranded outside its own folder.
      if vim.fn.rename(single, folder .. '/solution-1.cpp') ~= 0 then
        vim.notify('Could not move ' .. single .. ' into ' .. folder, vim.log.levels.ERROR)
        return
      end
      target = folder .. '/solution-2.cpp'
    else
      vim.fn.mkdir(judge_dir, 'p')
      target = single
    end

    if vim.fn.writefile(lines, target) == 0 then
      vim.notify('Saved ' .. vim.fn.fnamemodify(target, ':~'), vim.log.levels.INFO)
    else
      vim.notify('Could not write ' .. target, vim.log.levels.ERROR)
    end
  end)
end

return {
  {
    'xeluxee/competitest.nvim',
    -- nui.nvim is not optional: competitest's README lists it as a dependency.
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CompetiTest',
    -- <leader>r, not <leader>c: LazyVim puts the LSP actions on <leader>c and
    -- sets them per buffer, so a buffer-local <leader>cr (Rename) and
    -- <leader>ca (Code Action) beat a global mapping in exactly the C++ files
    -- where the testcase runner is needed. r for run.
    keys = {
      { '<leader>rr', '<cmd>CompetiTest run<cr>', desc = 'Run all testcases' },
      { '<leader>ra', '<cmd>CompetiTest add_testcase<cr>', desc = 'Add a testcase' },
      { '<leader>re', '<cmd>CompetiTest edit_testcase<cr>', desc = 'Edit a testcase' },
      { '<leader>rp', '<cmd>CompetiTest receive problem<cr>', desc = 'Pull problem from browser' },
      { '<leader>rc', '<cmd>CompetiTest receive contest<cr>', desc = 'Pull whole contest' },
      { '<leader>rs', archive_solution, desc = 'Save this solution to solved/' },
    },
    opts = {
      -- The default compile command is `g++ -Wall $(FNAME) -o $(FNOEXT)`: no
      -- standard and no optimisation, so modern C++ fails to build and a
      -- correct solution can still time out. These match Codeforces GNU G++23.
      compile_command = {
        cpp = { exec = 'g++', args = { '-std=c++23', '-O2', '-Wall', '$(FNAME)', '-o', '$(FNOEXT)' } },
      },
      -- Every received problem starts from this file instead of an empty buffer.
      template_file = { cpp = '~/Github/cp-setup/yo.cpp' },
      -- The default path is "$(CWD)/$(PROBLEM).$(FEXT)", and $(PROBLEM) is the
      -- raw title, so problem 4A lands in a file called "A. Watermelon.cpp".
      -- The space and the dot make the compiled binary painful to run from a
      -- shell. $(JAVA_TASK_CLASS) is the same name made identifier-safe.
      --
      -- Competitive Companion sends problems from any judge it supports, not
      -- only Codeforces, and every judge names its first problem "A". Without
      -- the $(JUDGE)/$(CONTEST) prefix an AtCoder A.cpp overwrites a
      -- Codeforces one. $(JUDGE) is the first part of the extension's `group`.
      received_problems_path = '$(CWD)/$(JUDGE)/$(CONTEST)/$(JAVA_TASK_CLASS).$(FEXT)',
      received_contests_directory = '$(CWD)/$(JUDGE)/$(CONTEST)',
    },
  },
  -- Name the prefix so which-key shows "Run (competitive programming)".
  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { '<leader>r', group = 'run (competitive programming)', icon = '' },
      },
    },
  },
}
