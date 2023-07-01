#!/bin/bash

# produce lines of the form: [ "language", n ]
function categories {
  curl -Ss 'http://rosettacode.org/mw/index.php?title=Special:Categories&limit=5000' |\
    grep "/wiki/Category:" | grep member | grep -v '(.*(' |\
    grep -v ' User</a>' |\
    sed -e 's/.*title="Category://' -e 's/member.*//'  |\
    sed 's:^\([^"]*\)"[^(]*(\(.*\):["\1", \2]:'
}

# produce lines of the form: "language"
function languages {
  curl -Ss 'http://rosettacode.org/wiki/Category:Programming_Languages' |\
    sed '/Pages in category "Programming Languages"/,$d' |\
    grep '<li><a href="/wiki/Category:' | fgrep title= |\
    sed 's/.*Category:\([^"]*\)".*/"\1"/'
}

categories |\
  /usr/local/bin/jq --argfile languages <(languages) -s -r '

  # input: array of [score, _] sorted by score
  # output: array of [ranking, score, _]
  def ranking:
    reduce .[] as $x
      ([];   # array of [count, rank, score, _]
       if length == 0 then [[1, 1] + $x]
       else .[length - 1] as $previous
       | if $x[0] == $previous[2]
         then . + [ [$previous[0] + 1, $previous[1]] + $x ]
         else . + [ [$previous[0] + 1, $previous[0] + 1] + $x ]
         end
       end)
    | [ .[] | .[1:] ];

    # Every language page has three category pages that should be excluded
    (reduce .[] as $pair
      ({};
       ($pair[1] as $n | if $n > 3 then . + {($pair[0]): ($n - 3)} else . end ))) as $freq
  | [ $languages[] | select($freq[.] != null) |  [$freq[.], .]]
  | sort
  | reverse
  | ranking[]
  | "\(.[0]).  \(.[1]) - \(.[2])" '
