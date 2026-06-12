my @cat = (1..*).map: { :2([~] .base(2) xx 2) };
say "{+$_} matching numbers\n{.batch(5)».map({$_ ~ .base(2).fmt('(%s)')})».fmt('%15s').join: "\n"}\n"
    given @cat[^(@cat.first: * > 1000, :k)];
