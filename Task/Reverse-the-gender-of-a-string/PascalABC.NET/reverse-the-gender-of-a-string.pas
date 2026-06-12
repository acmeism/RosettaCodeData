var words := Arr('She', 'she', 'Her',  'her',  'hers', 'He',   'he',   'His',  'his',  'him');
var repls := Arr('He_', 'he_', 'His_', 'his_' ,'his_', 'She_', 'she_', 'Her_', 'her_', 'her_');

function ReverseGender(s: string): string;
begin
  foreach var (w,r) in words.Zip(repls) do
    s := Regex.Replace(s,'\b'+w+'\b',r);
  Result := s.Replace('_','');;
end;

begin
  var sentences := Arr(
  'She was a soul stripper. She took his heart!',
  'He was a soul stripper. He took her heart!',
  'She wants what''s hers, he wants her and she wants him!',
  'Her dog belongs to him but his dog is hers!'
  );
  foreach var sentence in sentences do
    Println(ReverseGender(sentence));
end.
