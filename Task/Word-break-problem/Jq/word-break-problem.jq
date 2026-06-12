def words: ["a", "bc", "abc", "cd", "b"];
def strings: ["abcd", "abbc", "abcbcd", "acdbc", "abcdd"];

# input: an array of allowed words
# output: a stream giving all possible parses of the given string into
# the allowed words; each output is an array showing how the string
# has been parsed.
def string2words(string):
   . as $dict
   # Input: array of words
   # Output: augmented array
   | def s2w(s):
       if s=="" then .
       else $dict[] as $word
       | (s|startswith($word)) as $ix
       | if $ix
         then s[$word|length:] as $rest
         | (. + [$word]) | s2w($rest)
	 else empty
	 end
       end;
   [] | s2w(string);

def count(s): reduce s as $x (0; .+1) ;

def demo1:
  strings[] as $s
  | words
  | (first(string2words($s)) // []) as $parsed
  | "\($s) => \($parsed|join(" "))" ;

def demo2:
  strings[] as $s
  | words
  | count(string2words($s))
  | "\($s) has \(.) parse\(if . == 1 then "" else "s" end)." ;

# demo3 assumes an invocation along the lines of:
#  jq  -Rrn -f program.jq unixdict.txt
def demo3:
  "returntotal" as $s
  | "\($s) has \([inputs] |  count(string2words($s)) parses."

demo1, " ", demo2, "", demo3

