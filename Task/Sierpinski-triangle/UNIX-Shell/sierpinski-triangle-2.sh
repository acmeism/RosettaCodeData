#!/bin/bash

### BASH (pure-bash)
### https://rosettacode.org/wiki/Bourne_Again_SHell
### Ported from bash+sed+tr version
### Tested with bash versions 3.2.57 and 5.2.9
### This version completely avoids any number-theoretic workarounds.
### Instead, it repeatedly replaces characters by "blocks of characters".
### The strategy is in no way bash-specific,
### it would work with any other language just as well,
### but is particularly well suited for Bash Parameter Expansion
###     ${parameter/pattern/string}
### syntax used for pure-bash global-pattern-substitution.
### (Search "man bash" output for "Parameter Expansion" for additional details
###  on the
###     ${parameter/pattern/string}
###  and
###     ${parameter:-word}
###  syntax)

# Basic principle:
#
#
#  x ->  dxd       d -> dd      s -> s
#        xsx            dd           s
#
# In the end all 'd' and 's' are removed.
function rec(){
  if [ $1 == 0 ]
  then
    echo "x"
  else
    rec $[ $1 - 1 ] | while read line ; do
      A="$line" ; A="${A//d/dd}" ; A="${A//x/dxd}" ; echo "$A"
      A="$line" ; A="${A//d/dd}" ; A="${A//x/xsx}" ; echo "$A"
    done
  fi
}

### If the script has no arguments, then the default is n=4
### Else n is the first argument to the script
export n="${1:-4}"

B="$(rec "$n")" ; B="${B//d/ }" ; B="${B//s/ }" ; B="${B//x/*}"
echo "$B"
