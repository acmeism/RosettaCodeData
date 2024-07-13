##
var n := 1000;
(3..n-1).Where(i -> i.Divs(3) or i.Divs(5)).Sum.Println
