-- Dadbod connections from env / local secrets file (never commit passwords).
--
-- Supported env vars (any that are set get added):
--   DATABASE_URL / DBUI_URL          → connection named "default"
--   DBUI_NAME                        → optional name for DATABASE_URL / DBUI_URL
--   DB_DEV_URL / DB_STAGING_URL / DB_PROD_URL
--   DB_<NAME>_URL                    → e.g. DB_NEON_URL → "neon"
--
-- Or create (gitignored) lua/config/db-secrets.lua:
--   return {
--     { name = "local", url = "postgres://user:pass@127.0.0.1:5432/mydb" },
--     { name = "tunnel", url = "postgres://user:pass@127.0.0.1:5433/mydb" },
--   }
--
-- Remote tunnel flow:
--   1. ssh -L 5433:db.internal:5432 -N user@bastion   (or cloudflared / etc.)
--   2. point url at 127.0.0.1:5433
--   3. <leader>D → DBUI → run queries with <leader>S

local function collect_dbs()
  local dbs = {}
  local seen = {}

  local function add(name, url)
    if not url or url == "" or seen[name] then
      return
    end
    seen[name] = true
    dbs[#dbs + 1] = { name = name, url = url }
  end

  -- Primary URL
  local primary = vim.env.DATABASE_URL or vim.env.DBUI_URL
  if primary then
    add(vim.env.DBUI_NAME or "default", primary)
  end

  -- Common named shortcuts
  add("dev", vim.env.DB_DEV_URL)
  add("staging", vim.env.DB_STAGING_URL)
  add("prod", vim.env.DB_PROD_URL)

  -- Any DB_<NAME>_URL from the environment
  for key, value in pairs(vim.fn.environ()) do
    local name = key:match("^DB_([%w_]+)_URL$")
    if name and value and value ~= "" then
      add(name:lower(), value)
    end
  end

  -- Optional local secrets module (gitignored)
  local ok, secrets = pcall(require, "config.db-secrets")
  if ok and type(secrets) == "table" then
    for _, conn in ipairs(secrets) do
      if type(conn) == "table" and conn.name and conn.url then
        add(conn.name, type(conn.url) == "function" and conn.url() or conn.url)
      end
    end
  end

  return dbs
end

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    init = function()
      local dbs = collect_dbs()
      if #dbs > 0 then
        vim.g.dbs = dbs
      end
    end,
  },
}
