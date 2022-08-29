local http = require('http.client')

local M = {}

M.config = {
  ['host'] = '127.0.0.1',
  ['port'] = 2023,
  ['http'] = nil
}

function M.setup(host, port)
  M.config['host'] = host
  M.config['port'] = port
  M.config['http'] = http.new({ max_connections = 30 })
  return M
end

function M.request(cmd)
  local host = 'http://' .. M.config.host .. ':' .. M.config.port .. '/'
  local url  = host .. M.trim(cmd)
  local response = M.config['http']:get(url)

  if response.status == 200 then
    return M.trim(response.body)
  end
end

function M.get()
  return M.request('get')
end

function M.flush()
  return M.request('flush')
end

function M.trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return M