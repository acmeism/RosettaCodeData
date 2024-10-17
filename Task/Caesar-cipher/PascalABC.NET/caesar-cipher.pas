##
function encrypt(msg:string;k:integer):string;
begin
  var big:=('A'..'Z').ToArray;
  var ltl:=('a'..'z').ToArray;
  foreach var c in msg do
    case c of
      'A'..'Z': result+=big[(big.IndexOf(c)+k) mod 26];
      'a'..'z': result+=ltl[(ltl.IndexOf(c)+k) mod 26];
      else result+=c;
    end;
end;
function decrypt(msg:string;k:integer):=encrypt(msg, 26-k);

var (key, message):=(3,'The five boxing wizards jump quickly');
Println('Original:',message);
message:=encrypt(message, 3);
Println('Encrypted:',message);
message:=decrypt(message, 3);
Println('Decrypted:',message);
