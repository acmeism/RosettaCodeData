include ffl/hct.fs

10 hct-create ht           \ create a hashtable with initial size 10

1 s" one"   ht hct-insert  \ ht["one"] = 1
2 s" two"   ht hct-insert  \ ht["two"] = 2
3 s" three" ht hct-insert  \ ht["three"] = 3
