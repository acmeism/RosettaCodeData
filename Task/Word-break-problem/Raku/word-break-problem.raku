my @words = <a bc abc cd b>;
my $regex = @words.join('|');

put "$_: ", word-break($_) for <abcd abbc abcbcd acdbc abcdd>;

sub word-break (Str $word) { ($word ~~ / ^ (<$regex>)+ $ /)[0] // "Not possible" }
