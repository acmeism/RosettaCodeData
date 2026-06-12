   tobase64 =:  padB64~ b2B64
     padB64 =:  , '=' #~ 0 2 1 i. 3 | #
     b2B64  =:  BASE64 {~ _6 #.\ (8#2) ,@:#: a.&i.
