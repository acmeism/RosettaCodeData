##
function random960: string;
begin
  var start := 'RKR';

  foreach var piece in 'QNN' do
    Insert(piece, start, Random(start.length + 1) + 1);

  var bishpos := Random(start.length + 1) + 1;
  Insert('B', start, bishpos);
  Insert('B', start, Range(bishpos + 1, start.Length + 1, 2).ToArray.RandomElement);
  result := start;
end;

random960.Println;
