sub to-Greek (Str $string is copy) {
    my %pre =  :Ph<F>, :ck<k>, :ee<h>, :J<I>, :rh<r>,:oo<w>, :ph<f>, :ch<χ>,
               :th<θ>, :ps<ψ>, :Ch<Χ>, :Th<Θ>, :Ps<Ψ>, :kh<χ>, 's ' => 'ς ';
    my %post = :a<α>, :b<β>, :d<δ>, :e<ε>, :f<φ>, :g<γ>, :h<η>, :i<ι>, :j<ι>,
               :k<κ>, :l<λ>, :m<μ>, :n<ν>, :o<ο>, :p<π>, :q<κ>, :r<ρ>, :s<σ>,
               :t<τ>, :u<υ>, :v<β>, :w<ω>, :x<ξ>, :y<υ>, :z<ζ>, :A<Α>, :B<Β>,
               :D<Δ>, :E<Ε>, :F<Φ>, :G<Γ>, :H<Η>, :I<Ι>, :L<Λ>, :M<Μ>, :N<Ν>,
               :O<Ο>, :P<Π>, :Q<Κ>, :R<Ρ>, :S<Σ>, :T<Τ>, :U<Υ>, :W<Ω>, :X<Ξ>,
               :Z<Ζ>;

    $string.=subst(:g, .key, .value ) for flat %pre, %post;
    $string
}

my $text = chomp q:to/ENGLISH/;
    The quick brown fox jumped over the lazy dog.

    I was looking at some rhododendrons in my back garden,
    dressed in my khaki shorts, when the telephone rang.

    As I answered it, I cheerfully glimpsed that the July sun
    caused a fragment of black pine wax to ooze on the velvet quilt
    laying in my patio.

    sphinx of black quartz, judge my vow.
    ENGLISH

say "English:\n\n" ~ $text ~ "\n" ~ '=' x 80;

say "\"Greek\":\n\n" ~ $text.&to-Greek ~ "\n" ~ '=' x 80;

say "Or, to named characters:\n\n$_\n" ~
  .&to-Greek.comb.map({ .match(/\W/) ?? $_ !!
      '<' ~ .uniname.subst( /.+<?after LETTER\s>/).lc ~ '>'
  }).join
  given 'sphinx of black quartz, judge my vow.';
