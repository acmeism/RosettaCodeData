def check(ans): longest_common_prefix == ans;

(["interspecies","interstellar","interstate"] | check("inters")) and
(["throne","throne"]                          | check("throne")) and
(["throne","dungeon"]                         | check("")) and
(["throne", "", "throne"]                     | check("")) and
(["cheese"]                                   | check("cheese")) and
([""]                                         | check("")) and
([]                                           | check("")) and
(["prefix","suffix"]                          | check("")) and
(["foo","foobar"]                             | check("foo"))
