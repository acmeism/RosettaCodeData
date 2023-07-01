function getLower(a,b)
  local i,j=1,1
  return function()
    if not b[j] or a[i] and a[i]<b[j] then
      i=i+1; return a[i-1]
    else
      j=j+1; return b[j-1]
    end
  end
end

function merge(a,b)
  local res={}
  for v in getLower(a,b) do res[#res+1]=v end
  return res
end

function mergesort(list)
  if #list<=1 then return list end
  local s=math.floor(#list/2)
  return merge(mergesort{unpack(list,1,s)}, mergesort{unpack(list,s+1)})
end
