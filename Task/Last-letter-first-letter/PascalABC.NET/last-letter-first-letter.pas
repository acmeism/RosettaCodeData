var
  names: array of string := (
      'audino', 'bagon', 'baltoy', 'banette', 'bidoof',
      'braviary', 'bronzor', 'carracosta', 'charmeleon', 'cresselia',
      'croagunk', 'darmanitan', 'deino', 'emboar', 'emolga',
      'exeggcute', 'gabite', 'girafarig', 'gulpin', 'haxorus',
      'heatmor', 'heatran', 'ivysaur', 'jellicent', 'jumpluff',
      'kangaskhan', 'kricketune', 'landorus', 'ledyba', 'loudred',
      'lumineon', 'lunatone', 'machamp', 'magnezone', 'mamoswine',
      'nosepass', 'petilil', 'pidgeotto', 'pikachu', 'pinsir',
      'poliwrath', 'poochyena', 'porygon2', 'porygonz', 'registeel',
      'relicanth', 'remoraid', 'rufflet', 'sableye', 'scolipede',
      'scrafty', 'seaking', 'sealeo', 'silcoon', 'simisear',
      'snivy', 'snorlax', 'spoink', 'starly', 'tirtouga',
      'trapinch', 'treecko', 'tyrogue', 'vigoroth', 'vulpix',
      'wailord', 'wartortle', 'whismur', 'wingull', 'yamask');

var
  maxPathLength := 0;
  maxPathLengthCount := 0;
  maxPathExample := '';

procedure search(part: array of string; offset: integer);
begin
  if (offset > maxPathLength) then
  begin
    maxPathLength := offset;
    maxPathLengthCount := 1;
  end
  else if (offset = maxPathLength) then
  begin
    maxPathLengthCount += 1;
    maxPathExample := '';
    foreach var i in (0..offset - 1) do
      maxPathExample := maxpathexample + (if (i mod 5 = 0) then #10 else ' ') + part[i];
  end;
  var lastChar := part[offset - 1].last;
  foreach var i in (offset..part.Length - 1) do
    if (part[i][1] = lastChar) then
    begin
      Swap(names[offset], names[i]);
      search(names, offset + 1);
      Swap(names[offset], names[i]);
    end;
end;

begin
  foreach var i in (0..names.Length - 1) do
  begin
    Swap(names[0], names[i]);
    search(names, 1);
    Swap(names[0], names[i]);
  end;
  println('Maximum path length         : ', maxPathLength);
  println('Paths of that length        : ', maxPathLengthCount);
  println('Example path of that length : ', maxPathExample);
end.
