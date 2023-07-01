#!/usr/bin/env raku

# 20200501 Raku programming solution

use NativeCall;

constant LIBTEST = '/home/user/LibTest.so';

sub test(uint8 $a, uint8 $b) returns uint8 is native(LIBTEST) { * };

say test 7, 12;
