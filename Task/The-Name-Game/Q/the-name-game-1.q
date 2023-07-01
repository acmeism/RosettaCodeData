game_ssr:{[Name]
  V:raze 1 lower\"AEIOUY";                                        / vowels
  tn:lower((Name in V)?1b) _ Name;                                / truncated Name
  s3:{1(-1_)\x,"o-",x}lower first Name;                           / 3rd ssr
  s:"$1, $1, bo-b$2\nBanana-fana-fo-f$2\nFee-fimo-m$2\n$1!\n\n";
  (ssr/).(s;("$1";"$2";s3 0);(Name;tn;s3 1)) }
