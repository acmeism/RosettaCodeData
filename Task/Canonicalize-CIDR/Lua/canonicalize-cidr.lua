inet = require 'inet'

test_cases = {
  '87.70.141.1/22', '36.18.154.103/12', '62.62.197.11/29', '67.137.119.181/4',
  '161.214.74.21/24', '184.232.176.184/18'
}

for i, cidr in ipairs(test_cases) do
  print( inet(cidr):network() )
end
