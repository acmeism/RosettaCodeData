use XML::Writer;

my @students =
    [ Q[April],         Q[Bubbly: I'm > Tam and <= Emily] ],
    [ Q[Tam O'Shanter], Q[Burns: "When chapman billies leave the street ..."] ],
    [ Q[Emily],         Q[Short & shrift] ]
;

my @lines = map { :Character[:name(.[0]), .[1]] }, @students;

say XML::Writer.serialize( CharacterRemarks => @lines );
