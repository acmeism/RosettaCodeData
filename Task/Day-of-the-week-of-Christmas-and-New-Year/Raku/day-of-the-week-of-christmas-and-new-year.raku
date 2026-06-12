my @d-o-w = < Sunday Monday Tuesday Wednesday Thursday Friday Saturday >;

.say for (flat 2020..2022, (1500 .. 2500).roll(7)).sort.map: {
     "In {$_}, New Years is on a { @d-o-w[Date.new($_,  1,  1).day-of-week % 7] }, " ~
     "and Christmas on a { @d-o-w[Date.new($_, 12, 25).day-of-week % 7] }."
}
