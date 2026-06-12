// Unescape a string. Nigel Galloway: October 10th., 2024
##
var tests := |'abc', 'a☺c', 'a\"c', '\u0061\u0062\u0063', 'a\\c', 'a\\u263Ac', 'a\uD834\uDD1Ec', 'a\ud834\udd1ec', 'a\u263', 'a\u263Xc', 'a\uDD1Ec', 'a\uD834c', 'a\uD834c', 'a\uD834\u263Ac'|;
foreach var n in tests do try
    println(System.Text.RegularExpressions.Regex.Unescape(n))except
    on e:Exception do writeln(e.Message); end;

