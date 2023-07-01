local requests = require('requests')
local auth = requests.HTTPBasicAuth('admin', 'admin')
local resp, e = requests.get({
  url = 'https://httpbin.org/basic-auth/admin/admin',
  auth = auth
})
io.write(string.format('Status: %d', resp.status_code))
