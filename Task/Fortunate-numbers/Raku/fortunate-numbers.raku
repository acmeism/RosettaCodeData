my @primorials = [\*] grep *.is-prime, ^∞;

say display :title("First 50 distinct fortunate numbers:\n"),
   (squish sort @primorials[^75].hyper.map: -> $primorial {
       (2..∞).first: (* + $primorial).is-prime
   })[^50];

sub display ($list, :$cols = 10, :$fmt = '%6d', :$title = "{+$list} matching:\n") {
    cache $list;
    $title ~ $list.batch($cols)».fmt($fmt).join: "\n"
}
