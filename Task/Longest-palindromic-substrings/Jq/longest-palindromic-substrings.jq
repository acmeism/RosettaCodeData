def longestPalindromicSubstring:
  length as $len
  | if $len <= 1 then .
    else explode as $s
    | {targetLen: $len, longest: [], i: 0}
    | until(.stop;
        (.i + .targetLen - 1) as $j
        | if $j < $len
          then $s[.i:$j+1] as $ss
           | if $ss == ($ss|reverse) then .longest += [$ss] else . end
           | .i += 1
          else
            if .longest|length > 0 then .stop=true else . end
            | .i = 0
            | .targetLen += - 1
	  end )
     | .longest
     | map(implode)
     | unique
     end ;

def strings:
  ["babaccd", "rotator", "reverse", "forever", "several", "palindrome", "abaracadaraba"];

"The palindromic substrings having the longest length are:",
(strings[]
 | longestPalindromicSubstring as $longest
 | "  \(.): length \($longest[0]|length) -> \($longest)"
)
