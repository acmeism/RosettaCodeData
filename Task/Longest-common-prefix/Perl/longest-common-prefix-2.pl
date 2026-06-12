use Test::More;
plan tests => 8;

is lcp("interspecies","interstellar","interstate"), "inters";
is lcp("throne","throne"),                          "throne";
is lcp("throne","dungeon"),                         "";
is lcp("cheese"),                                   "cheese";
is lcp(""),                                         "";
is lcp(),                                           "";
is lcp("prefix","suffix"),                          "";
is lcp("foo","foobar"),                             "foo";
