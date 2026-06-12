put display 'unixdict.txt'.IO.words».fc.grep({ (.index('a')//next) < (.index('b')//next) < (.index('c')//next) }),
     :11cols, :fmt('%-12s');

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n" )   {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
