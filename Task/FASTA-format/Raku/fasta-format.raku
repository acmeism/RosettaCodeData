grammar FASTA {

    rule TOP    { <entry>+ }
    rule entry  { \> <title> <sequence> }
    token title { <.alnum>+ }
    token sequence { ( <.alnum>+ )+ % \n { make $0.join } }

}

FASTA.parse: q:to /§/;
>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED
§

for $/<entry>[] {
    say ~.<title>, " : ", .<sequence>.made;
}
