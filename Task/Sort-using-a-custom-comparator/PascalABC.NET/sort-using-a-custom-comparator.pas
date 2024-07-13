type
  Pair = auto class
    Name,Value: string;
  end;

begin
  var a: array of Pair := (new Pair('ZZZ','333'),new Pair('XXX','222'),new Pair('YYY','111'));
  Sort(a, (p1,p2) -> p1.Name < p2.Name);
  Print(a);
end.
