sub infix:<⋅> { [+] @^a »×« @^b }
sub norm      (@v) { sqrt @v⋅@v }
sub normalize (@v) { @v X/ @v.&norm }
sub getAngle  (@v1,@v2) { 180/π × acos (@v1⋅@v2) / (@v1.&norm × @v2.&norm) }

sub crossProduct ( @v1, @v2 ) {
    my \a = <1 2 0>; my \b = <2 0 1>;
    (@v1[a] »×« @v2[b]) »-« (@v1[b] »×« @v2[a])
}

sub aRotate ( @p, @v, $a ) {
    my \ca = cos $a/180×π;
    my \sa = sin $a/180×π;
    my \t = 1 - ca;
    my (\x,\y,\z) = @v;
    map { @p⋅$_ },
        [   ca + x×x×t, x×y×t -  z×sa, x×z×t +  y×sa],
        [x×y×t +  z×sa,    ca + y×y×t, y×z×t -  x×sa],
        [z×x×t -  y×sa, z×y×t +  x×sa,    ca + z×z×t]
}

my @v1 = [5,-6,  4];
my @v2 = [8, 5,-30];
say join ' ', aRotate @v1, normalize(crossProduct @v1, @v2), getAngle @v1, @v2;
