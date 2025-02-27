##
var gen := '_###_##_#_#_#_#__#__'.Select(ch -> (if ch = '#' then 1 else 0)).ToList;
loop 10 do
begin
  gen.Select(n -> (if n = 1 then '#' else '_')).println;
  gen := (0 + gen + 0).ToList;
  gen := (1..gen.Count - 2).Select(m -> (if gen[m - 1:m + 2].Sum = 2 then 1 else 0)).ToList;
end;
