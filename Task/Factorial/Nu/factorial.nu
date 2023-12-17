def 'math factorial' [] {[$in 1] | math max | 1..$in | math product}

..10 | each {math factorial}
