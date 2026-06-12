multi lcp()    { '' }
multi lcp($s)  { ~$s }
multi lcp(*@s) { substr @s[0], 0, [+] [\and] [Zeqv] |@s».ords }

use Test;
plan 8;

is lcp("interspecies","interstellar","interstate"), "inters";
is lcp("throne","throne"), "throne";
is lcp("throne","dungeon"), '';
is lcp("cheese"), "cheese";
is lcp(''), '';
is lcp(), '';
is lcp("prefix","suffix"), '';
is lcp("foo","foobar"), 'foo';
