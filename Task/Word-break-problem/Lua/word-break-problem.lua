-- a specialized dict format is used to minimize the
-- possible candidates for this particalur problem
function genDict(ws)
  local d,dup,head,rest = {},{}
  for w in ws:gmatch"%w+" do
    local lw = w:lower()
    if not dup[lw] then
      dup[lw], head,rest = true, lw:match"^(%w)(.-)$"
      d[head] = d[head] or {n=-1}
      local len = #rest
      d[head][len] = d[head][len] or {}
      d[head][len][rest] = true
      if len>d[head].n then
        d[head].n = len
      end
    end
  end
  return d
end

-- sample default dict
local defWords = "a;bc;abc;cd;b"
local defDict = genDict(defWords)

function wordbreak(w, dict)
  if type(w)~='string' or w:len()==0 then
    return nil,'emprty or not a string'
  end

  dict = type(dict)=='string' and genDict(dict) or dict or defDict

  local r, len = {}, #w

  -- backtracking
  local function try(i)
    if i>len then return true end
    local head = w:sub(i,i):lower()
    local d = dict[head]
    if not d then return end
    for j=math.min(d.n, len-i),0,-1 do -- prefer longer first
      if d[j] then
        local rest = w:sub(i+1,i+j):lower()
        if d[j][rest] then
          r[1+#r] = w:sub(i,i+j)
          if try(i+j+1) then
            return true
          else
            r[#r]=nil
          end
        end
      end
    end
  end

  if try(1) then
    return table.unpack(r)
  else
    return nil,'-no solution-'
  end
end

-- test
local test = {'abcd','abbc','abcbcd','acdbc','abcdd'  }
for i=1,#test do
  print(test[i],wordbreak(test[i]))
end
