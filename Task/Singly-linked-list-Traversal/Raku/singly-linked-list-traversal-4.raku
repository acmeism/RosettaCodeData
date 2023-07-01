my $list = (cons 10, (cons 20, (cons 30, Nil)));

for $list.Seq -> $cell {
    say $cell.value;
}
