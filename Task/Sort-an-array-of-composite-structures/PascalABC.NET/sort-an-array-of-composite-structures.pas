type
  Pair = auto class
    Name,Value: string;
  end;

begin
  var a: array of Pair := (new Pair('ZZZ','333'),new Pair('XXX','222'),new Pair('YYY','111'));
  a.OrderBy(p -> p.Name).Println;
  a.OrderBy(p -> p.Value).Println;
end.
