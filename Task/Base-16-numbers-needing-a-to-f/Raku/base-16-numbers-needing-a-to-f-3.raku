use Base::Any;

put display :20cols, :fmt('%3d'), (^501).grep( { .&to-base(-16).contains: /<[A..F]>/ } );

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n" )   {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
