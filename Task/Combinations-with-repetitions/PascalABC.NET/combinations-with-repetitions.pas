##
var t:=|'iced', 'jam', 'plain'|;
var p:=t.CartesianPower(2).Where(t->t[0]<=t[1]);
write($'{p.Count}');
Print(':');
p.Println;
write((1..10).CartesianPower(3).Where(t->(t[0]<=t[1])and(t[1]<=t[2])).count);
Print(': Choices of 3 from 10');
