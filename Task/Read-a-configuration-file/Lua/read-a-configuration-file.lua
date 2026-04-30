local conf = {}

-- Parsing
for line in io.lines"conf.txt" do
  local option, delim, value = line:match'^%s*([^;# \t=]+)([%s=]?)%s*(.-)%s*$'
  if option then
    if value:find',' then local oldvalue
      oldvalue, value = value, {}
      for field in oldvalue:gmatch'[^,]+' do
        table.insert(value, field:match"^%s*(.-)%s*$")
      end
    else
      value = delim~="" and value~="" and value or true
    end
    conf[option:lower()] = value
  end
end

-- Printing tables is usually left to the external module inspect
print(require"inspect"(conf))
