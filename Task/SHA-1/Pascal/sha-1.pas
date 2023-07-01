program RosettaSha1;
uses
    sha1;
var
   d: TSHA1Digest;
begin
     d:=SHA1String('Rosetta Code');
     WriteLn(SHA1Print(d));
end.
