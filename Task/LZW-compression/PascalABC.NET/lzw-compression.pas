function Compress(uncompressed: string): list<integer>;
begin
  // build the dictionary
  var dictionary := new Dictionary<string, integer>;
  for var i := 0 to 255 do
    dictionary[Chr(i).ToString] := i;

  var w := '';
  var compressed := new List<integer>;

  foreach var c in uncompressed do
  begin
    var wc := w + c;
    if wc in dictionary then w := wc
    else begin
      // write w to output
      compressed.Add(dictionary[w]);
      // wc is a new sequence; add it to the dictionary
      dictionary[wc] := dictionary.Count;
      w := c.ToString;
    end;
  end;

  // write remaining output if necessary
  if w <> '' then compressed.Add(dictionary[w]);
  result := compressed;
end;

function Decompress(compressed: list<integer>): string;
begin
  // build the dictionary
  var dictionary := new Dictionary<integer, string>;
  for var i := 0 to 255 do
    dictionary[i] := Chr(i).ToString;

  var w := dictionary[compressed[0]];
  compressed.RemoveAt(0);
  var decompressed := new StringBuilder(w);

  foreach var k in compressed do
  begin
    var entry := '';
    if  k in dictionary then entry := dictionary[k]
    else
      if k = dictionary.Count then entry := w + w[0];

    decompressed.Append(entry);

    // new sequence; add it to the dictionary
    dictionary[dictionary.Count] := w + entry[1];

    w := entry;
  end;

  result := decompressed.ToString;
end;

begin
  var compressed := Compress('TOBEORNOTTOBEORTOBEORNOT');
  Writeln(compressed);
  var decompressed := Decompress(compressed);
  Writeln(decompressed);
end.
