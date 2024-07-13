##
Println('abcd'.StartsWith('ab'));
Println('abcd'.EndsWith('cd'));
var abra := 'abracadabra';
Println('bra' in abra);
var ind := abra.IndexOf('bra');
var ind1 := abra.IndexOf('bra', ind + 1);
Println(ind,ind1);
abra.Matches('bra').Select(m -> m.Index).Println
