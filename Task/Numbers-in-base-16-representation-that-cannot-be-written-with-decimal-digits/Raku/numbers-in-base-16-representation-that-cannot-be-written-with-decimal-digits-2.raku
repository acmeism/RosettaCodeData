#Filter out such numbers from a range:
put "Filter: {+$_} such numbers:\n", .batch(20)».fmt('%3d').join("\n")
    given (1..500).grep( { so all |.map: { .polymod(16 xx *) »>» 9 } } );

#Generate such numbers directly, up to a threshold:
put "\nGenerate: first {+$_}:\n", .batch(10)».map({ "{$_}({:16($_)})" })».fmt('%9s').join("\n") given
    ((1..^Inf).grep(* % 7).map( { .base(7).trans: [1..6] => ['A'..'F'] } )).grep(!*.contains: 0)[^42];

#Count such numbers directly, up to a threshold
my $upto = 500;
put "\nCount: " ~ [+] flat (map {exp($_, 6)}, 1..($upto.log(16).floor)),
+(exp($upto.log(16).floor, 16) .. $upto).grep( { so all |.map: { .polymod(16 xx *) »>» 9 } });
