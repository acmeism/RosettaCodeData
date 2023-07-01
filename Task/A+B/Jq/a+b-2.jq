def addpairs:
  if length < 2 then empty
  else (.[0] + .[1]), (.[2:] | addpairs)
  end;

addpairs
