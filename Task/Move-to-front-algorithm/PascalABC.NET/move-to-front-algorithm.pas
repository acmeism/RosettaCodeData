const
  SymbolTable = Lst('a'..'z');

function encode(s: string): list<integer>;
begin
  result := new List<integer>;
  var symtable := SymbolTable;
  foreach var c in s do
  begin
    var idx := symtable.IndexOf(c);
    result.add(idx);
    symtable.RemoveAt(idx);
    symtable.Insert(0, c);
  end;
end;

function decode(s: list<integer>): string;
begin
  var symtable := SymbolTable;
  foreach var idx in s do
  begin
    var c := symtable[idx];
    result += c;
    symtable.RemoveAt(idx);
    symtable.Insert(0, c);
  end;
end;

begin
  foreach var word in ['broood', 'babanaaa', 'hiphophiphop'] do
  begin
    var encoded := encode(word);
    var decoded := decode(encoded);
    var status := if decoded = word then 'correctly' else 'incorrectly';
    println(word, 'encodes to', encoded, 'which', status, 'decodes to', decoded);
  end;
end.
