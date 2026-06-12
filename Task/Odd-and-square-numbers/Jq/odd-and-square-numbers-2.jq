# input: an array
# output: a stream of arrays of size size except possibly for the last array
def group(size):
  recurse( .[size:]; length>0) | .[0:size];

foreach range(0; 5) as $p ({pow:1};
    .low = (.pow|sqrt|ceil)
    | if .low % 2 == 0 then .low += 1 else . end
    | .pow *= 10 ;

    [range(.low; 1 + (.pow|sqrt|floor); 2) | . * . ] as $oddSq
    | "\($oddSq|length) odd squares from \(.pow/10) to \(.pow):",
      ( $oddSq | group(10) | join(" ")), "" )
