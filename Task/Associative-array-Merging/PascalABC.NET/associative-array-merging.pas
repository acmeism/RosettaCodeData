begin
  var base := Dict(('name','Rocket Skates'),
    ('price','12.75'),
    ('color','yellow'));

  var update := Dict(('price','15.25'),
    ('color','red'),
    ('year','1974'));

  var merged := new Dictionary<string,string>;
  foreach var kv in base.Concat(update) do
    merged[kv.Key] := kv.Value;
  merged.PrintLines
end.
