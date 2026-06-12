put display :20cols, :fmt('%3d'), (^501).grep( { so any |.map: { .polymod(16 xx *) »>» 9 } } );

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n" )   {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
