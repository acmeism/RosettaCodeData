sub multisplit($str, @seps) { $str.split: / ||@seps /, :v }

my @chunks = multisplit 'a!===b=!=c==d', < == != = >;

# Print the strings.
say @chunks».Str.raku;

# Print the positions of the separators.
for grep Match, @chunks -> $s {
    say "{$s.fmt: '%2s'} from {$s.from.fmt: '%2d'} to {$s.to.fmt: '%2d'}";
}
