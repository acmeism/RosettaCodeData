def dimensions:
  def same(f):
    if length == 0 then true
    else (.[0]|f) as $first | reduce .[] as $i (true; if . then ($i|f) == $first else . end)
    end;

  if type == "array"
  then if length == 0 then [0]
       elif same( dimensions ) then [length] + (.[0]|dimensions)
       else null
       end
  else []
  end;
