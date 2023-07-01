local items = {1,2,3,4,1,2,3,4,0/0,nil,"bird","cat","dog","dog","bird",0/0}

function rmdup(t)
  local r,dup,c,NaN = {},{},1,{}
  for i=1,#t do
    local e = t[i]
    local k = e~=e and NaN or e
    if k~=nil and not dup[k] then
      c, r[c], dup[k]= c+1, e, true
    end
  end
  return r
end

print(table.concat(rmdup(items),' '))
