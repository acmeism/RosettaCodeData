use Digest::SHA1::Native;

my %ladies = < Alice Beth Cecilia Donna Eunice Fran Genevieve Holly Irene Josephine Kathlene Loralie Margaret
               Nancy Odelle Pamela Quinci Rhonda Stephanie Theresa Ursula Victoria Wren Yasmine Zoey >.map: -> $name {
    $name => {
        loves   => :16(sha1-hex($name).substr(0,4)),
        lovable => :16(sha1-hex($name).substr(*-4))
    }
}

my %sailors = < Ahab Brutus Popeye >.map: -> $name {
    $name => {
        loves   => :16(sha1-hex($name).substr(0,4)),
        lovable => :16(sha1-hex($name).substr(*-4))
    }
}

for %sailors.sort( *.key ) -> $sailor {
    printf "%6s will like: ", $sailor.key;
    say join ', ', my @likes = %ladies.sort( { abs $sailor.value.<loves> - .value.<loves> } ).head(10)».key;
    print '     Is liked by: ';
    say join ', ',  my @liked = %ladies.sort( { abs $sailor.value.<lovable> - .value.<lovable> } ).head(10)».key;
    my %matches;
    for @liked.reverse Z, (1..10) { %matches{.[0]} += .[1] };
    for @likes.reverse Z, (1..10) { %matches{.[0]} += .[1] };
    say 'Best match(s): ' ~ %matches.grep(*.value == %matches.values.max)».key.sort.join(', ');
    say '';
}
