   perm:{x@m@&n=(#?:)'m:!n#n:#x}

   perm[!3]
(0 1 2
 0 2 1
 1 0 2
 1 2 0
 2 0 1
 2 1 0)

   perm "abc"
("abc"
 "acb"
 "bac"
 "bca"
 "cab"
 "cba")

   `0:{1_,/" ",/: $x}' perm `$" "\"some random text"
some random text
some text random
random some text
random text some
text some random
text random some
