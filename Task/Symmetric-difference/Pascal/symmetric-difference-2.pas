program SymmetricDifference;

type
    charSet = set of Char;

var
    s1, s2, s3: charSet;
    ch: char;

begin
    s1 := ['a', 'b', 'c', 'd'];
    s2 := ['c', 'd', 'e', 'f'];
    s3 := s1 >< s2;

    for ch in s3 do
        write(ch, ' ');
    writeLn;
end.
