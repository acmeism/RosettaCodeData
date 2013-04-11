# Pretty printer for N dimensional arrays. Assumes that
# if the FIRST element in any particular level is an array,
# then ALL the elements at that level are arrays.
sub pretty_print ( @array, $indent = 0 ) {
    my $tab = 2;
    if @array[0] ~~ Array {
        say ' ' x $indent,"[";
        pretty_print( $_, $indent + $tab ) for @array;
        say ' ' x $indent, "]{$indent??','!!''}";
    } else {
        say ' ' x $indent, "[{say_it(@array)} ]{$indent??','!!''}";
    }

    sub say_it ( @array ) {
        return join ",", @array>>.fmt("%4s");
    }
}

my @f = (
  [
    [ -9,  5, -8 ], [  3,  5,  1 ],
  ],
  [
    [ -1, -7,  2 ], [ -5, -6,  6 ],
  ],
  [
    [  8,  5,  8 ], [ -2, -6, -4 ],
  ]
);

my @g = (
  [
    [  54,  42,  53, -42,  85, -72 ],
    [  45,-170,  94, -36,  48,  73 ],
    [ -39,  65,-112, -16, -78, -72 ],
    [   6, -11,  -6,  62,  49,   8 ],
  ],
  [
    [ -57,  49, -23,  52,-135,  66 ],
    [ -23, 127, -58,  -5,-118,  64 ],
    [  87, -16, 121,  23, -41, -12 ],
    [ -19,  29,  35,-148, -11,  45 ],
  ],
  [
    [ -55,-147,-146, -31,  55,  60 ],
    [ -88, -45, -28,  46, -26,-144 ],
    [ -12,-107, -34, 150, 249,  66 ],
    [  11, -15, -34,  27, -78, -50 ],
  ],
  [
    [  56,  67, 108,   4,   2, -48 ],
    [  58,  67,  89,  32,  32,  -8 ],
    [ -42, -31,-103, -30, -23,  -8 ],
    [   6,   4, -26, -10,  26,  12 ],
  ]
);

=begin skip_output

say "g =";
pretty_print( @g );

say '-' x 79;

say "f =";
pretty_print( @f );

say '-' x 79;
=end skip_output

say "# {+size_of(@f)}D array:";
say "h =";
pretty_print( deconv_ND( @g, @f ) );
