sub multisplit($str, @seps) { $str.split(/ ||@seps /, :v) }

my @chunks = multisplit( 'a!===b=!=c==d', < == != = > );

# Print the strings.
say @chunks».Str.perl;

# Print the positions of the separators.
for grep Match, @chunks -> $s {
    say "  $s   from $s.from() to $s.to()";
}
