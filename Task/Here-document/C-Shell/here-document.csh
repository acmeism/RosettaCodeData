#!/bin/csh -f
cat << ANARBITRARYTOKEN
 * Your HOME is $HOME
 * 2 + 2 is `@ n = 2 + 2; echo \$n`
ANARBITRARYTOKEN

cat << 'ANARBITRARYTOKEN'
$PATH \$PATH `shutdown now`
'ANARBITRARYTOKEN'
