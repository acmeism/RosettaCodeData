program PalindromeDetection;
var
  input, output: string;
  s: char; i: integer;
begin
  writeln('write down your input:');
  readln(input);
  output:='';
  for i:=1 to length(input) do
  begin
    s:=input[i];
    output:=s+output;
  end;
  writeln('');
  if(input=output)then
  writeln('input was palindrome')
  else
  writeln('input was not palindrome');
end.
