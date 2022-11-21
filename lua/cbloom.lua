local socket = require('socket')

local M = {}

M.config = {
  ['path'] = nil,
  ['sock'] = nil
}

function M.setup(path)
  M.config.path = path
  M.config.sock = socket.tcp_connect('unix/', path)
  M.config.sock:nonblock(true)
  M.config.sock:linger(false)
  return M
end

function M._send(cmd)
  local command = cmd .. '\r\n'
  return M.config.sock:send(command)
end

function M._read()
  return M.config.sock:read('\r\n')
end

function M.get()
  local response = M._send('get')
  if response ~= nil then
    return M._read()
  end
end

return M