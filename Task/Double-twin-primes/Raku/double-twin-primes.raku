sub dt { $^p, $p+2, $p+6, $p+8 }
.&dt.say for (^1000).grep: { all .&dt».is-prime };
