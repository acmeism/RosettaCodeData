use v6;
if 'a long string' ~~ /string$/ {
   say "It ends with 'string'";
}

# substitution has a few nifty features

$_ = 'The quick Brown fox';
s:g:samecase/\w+/xxx/;
.say;
# output:
# Xxx xxx Xxx xxx
