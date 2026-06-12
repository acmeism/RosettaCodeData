#!/bin/bash

# Actual shebang when using bash:
#!/usr/local/bin/script_gcc.sh

# Alternative shebang when using bash:
#!/bin/bash /usr/local/bin/script_gcc.sh

# CACHE=No # to turn off caching...

# Note: this shell should be re-written in actual C! :-)

DIALECT=c # or cpp
CC="gcc"
COPTS="-lm -x $DIALECT"
IEXT=.$DIALECT
OEXT=.out

ENOENT=2

srcpath="$1"; shift # => "$@"
#basename="$(basename "$srcpath" ."$DIALECT")"
basename="$(basename "$srcpath")"

# Warning: current dir "." is in path, AND */tmp directories are common/shared
paths="$(dirname "$srcpath")
$HOME/bin
/usr/local/bin
.
$HOME/tmp
$HOME
$HOME/Desktop"
#/tmp

while read dirnamew; do
  [ -w "$dirnamew" ] && break
done << end_here_is
$paths
end_here_is

compile(){
  sed -n '2,$p' "$srcpath" | "$CC" $COPTS -o "$binpath" -
}

if [ "'$CACHE'" = "'No'" ]; then
  binpath="$dirnamew/$basename-v$$$OEXT"
  if compile; then
    ( sleep 0.1; exec rm "$binpath" ) & exec "$binpath" "$@"
  fi
else
  while read dirnamex; do
    binpath="$dirnamex/$basename$OEXT"
    if [ -x "$binpath" -a "$binpath" -nt "$srcpath" ];
      then exec "$binpath" "$@"; fi
  done << end_here_is
$paths
end_here_is

  binpath="$dirnamew/$basename$OEXT"
  if compile; then exec "$binpath" "$@"; fi

  echo "$binpath: executable not available" 1>&2
  exit $ENOENT
fi
