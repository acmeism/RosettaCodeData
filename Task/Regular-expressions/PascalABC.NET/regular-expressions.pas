begin
  // text in tag (lazy quantification)
  var s := '<tag>abc</tag> def <tag>ghi</tag>';
  foreach var m in s.Matches('(?<=<tag>)(.*?)(?=</tag>)') do
    Println(m.Value, m.Index);

  // take words in parentheses
  s := 'one two three four five';
  Regex.Replace(s,'\w+','<$0>').Println;
end.
