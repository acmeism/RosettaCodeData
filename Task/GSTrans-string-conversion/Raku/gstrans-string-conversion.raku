# 20231105 Raku programming solution

sub GSTrans-encode(Str $str) {
   return [~] $str.encode('utf8').list.chrs.comb.map: -> $c {
      my $i = $c.ord;
      die "Char value of $c, $i, is out of range" unless 0 <= $i <= 255;
      given ($i,$c) {
         when 0 <= $i <= 31    { '|' ~ chr(64 + $i) }
         when $c eq '"'        { '|"' }
         when $c eq '|'        { '||' }
         when $i == 127        { '|?' }
         when 128 <= $i <= 255 { '|!' ~ GSTrans-encode(chr($i - 128)) }
         default               { $c }
      }
   }
}

sub GSTrans-decode(Str $str) {
   my ($gotbar, $gotbang, $bangadd) = False, False, 0;

   my @result = gather for $str.comb -> $c {
      if $gotbang {
         if $c eq '|' {
            $bangadd = 128;
            $gotbar = True;
         } else {
            take $c.ord + 128;
         }
         $gotbang = False;
      } elsif $gotbar {
         given $c {
            when $c eq '?' { take 127 + $bangadd }
            when $c eq '!' { $gotbang = True }
            when $c eq '|' || $c eq '"' || $c eq '<' { take $c.ord + $bangadd }
            when $c eq '[' || $c eq '{' { take 27 + $bangadd }
            when $c eq '\\' { take 28 + $bangadd }
            when $c eq ']' || $c eq '}' { take 29 + $bangadd }
            when $c eq '^' || $c eq '~' { take 30 + $bangadd }
            when $c eq '_' || $c eq '`' { take 31 + $bangadd }
            default { my $i = $c.uc.ord - 64 + $bangadd;
                      take $i >= 0 ?? $i !! $c.ord      }
         }
         $gotbar = False;
         $bangadd = 0;
      } elsif $c eq '|' {
         $gotbar = True
      } else {
         take $c.ord
      }
   }
   return Blob.new(@result).decode('utf8c8')
}

my @TESTS = <ALERT|G 'wert↑>;
my @RAND_TESTS = ^256 .roll(10).chrs.join xx 8;
my @DECODE_TESTS = < |LHello|G|J|M |m|j|@|e|!t|m|!|? abc|1de|5f >;

for |@TESTS, |@RAND_TESTS -> $t {
   my $encoded = GSTrans-encode($t);
   my $decoded = GSTrans-decode($encoded);
   say "String $t encoded is: $encoded, decoded is: $decoded.";
   die unless $t ~~ $decoded;
}
for @DECODE_TESTS -> $enc {
    say "Encoded string $enc decoded is: ", GSTrans-decode($enc);
}
