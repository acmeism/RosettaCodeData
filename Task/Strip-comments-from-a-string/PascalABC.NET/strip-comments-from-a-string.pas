function RemoveComments(s,delim: string): string
  := Regex.Replace(s, delim + '.+', '');

begin
  Writeln(RemoveComments('apples, pears # and bananas','#'));
  Writeln(RemoveComments('apples, pears ; and bananas',';'));
end.
