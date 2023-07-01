function splitdiff(s)
  for i=#s,2,-1 do
    if s:sub(i,i)~=s:sub(i-1,i-1) then
      s = s:sub(1,i-1)..', '.. s:sub(i,-1)
    end
  end
  return s
end
