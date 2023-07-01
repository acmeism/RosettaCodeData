local function validate(diagram)
  local lines = {}
  for s in diagram:gmatch("[^\r\n]+") do
    s = s:match("^%s*(.-)%s*$")
    if s~="" then lines[#lines+1]=s end
  end
  -- "a little of validation".."for brevity"
  assert(#lines>0, "FAIL:  no non-empty lines")
  assert(#lines%2==1, "FAIL:  even number of lines")
  return lines
end

local function parse(lines)
  local schema, offset = {}, 0
  for i = 2,#lines,2 do
    for part in lines[i]:gmatch("\|([^\|]+)") do
      schema[#schema+1] = { name=part:match("^%s*(.-)%s*$"), numbits=(#part+1)/3, offset=offset }
      offset = offset + (#part+1)/3
    end
  end
  return schema
end

local diagram = [[

  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |

+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

]] -- extra whitespace added for testing

local schema = parse(validate(diagram))
print("NAME       NUMBITS    OFFSET")
print("--------  --------  --------")
for i = 1,#schema do
  local item = schema[i]
  print(string.format("%-8s  %8d  %8d", item.name, item.numbits, item.offset))
end
