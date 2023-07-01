def commatize($s; $start; $step; $sep):

  def isExponent($c): "eEdDpP^∙x↑*⁰¹²³⁴⁵⁶⁷⁸⁹" | index($c);
  def rev: explode|reverse|implode;
  def addSeps($n; $dp):
       { $n, lz: "" }
       | if ($dp|not) and ($n|startswith("0")) and $n != "0"
         then .k = ($n|sub("^0*";""))
         | if (.k == "") then .k = "0" else . end
         | .lz = "0" * (($n|length) - (.k|length))
         | .n = .k
         else .
         end
       | if $dp
         then .n |= rev # reverse if after decimal point
         else .
         end
       | .i = (.n|length) - $step
       | until (.i < 1;
            .n = .n[: .i] + $sep + .n[.i :]
            | .i += - $step )
       | if $dp
         then .n |= rev # reverse again
         else .
         end
       | .lz + .n;

    { acc: $s[:$start],
        n: "",
       dp: false }
    | label $out
    | foreach (range($start; $s|length), null) as $j (.;
        if $j == null then .emit = true
        else $s[$j:$j+1] as $x
        | ($x | explode[0]) as $c
        | if ($c >= 48 and $c <= 57)
          then .n += $x
          | if $j == (($s|length)-1)
            then if (.acc != "" and isExponent(.acc[-1:]))
                 then .acc = $s
                 else .acc += addSeps(.n; .dp)
                 end
            else .
            end
          elif .n != ""
          then if (.acc != "" and isExponent(.acc[-1:]))
               then .acc = $s
               | .emit=true | ., break $out
               elif $x != "."
               then .acc +=  addSeps(.n; .dp) + $s[$j:]
               | .emit=true | ., break $out
               else .acc += addSeps(.n; .dp) + $x
               | .dp = true
               | .n = ""
               end
          else .acc += $x
          end
        end )
   | select(.emit)
   | $s, .acc, ""
;

# Input: the string to be commatized
def commatize:
  commatize(.; 0; 3; ",");

def defaults: [
    "\"-in Aus$+1411.8millions\"",
    "===US$0017440 millions=== (in 2000 dollars)",
    "123.e8000 is pretty big.",
    "The land area of the earth is 57268900(29% of the surface) square miles.",
    "Ain't no numbers in this here words, nohow, no way, Jose.",
    "James was never known as 0000000007",
    "Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.",
    "   $-140000±100 millions.",
    "6/9/1946 was a good year for some."
];

def exercise:
  commatize("123456789.123456789"; 0; 2; "*"),
  commatize(".123456789"; 0; 3; "-"),
  commatize("57256.1D-4"; 0; 4; "__"),
  commatize("pi=3.14159265358979323846264338327950288419716939937510582097494459231"; 0; 5; " "),
  commatize("The author has two Z$100000000000000 Zimbabwe notes (100 trillion)."; 0; 3; "."),

  (defaults[] | commatize) ;

exercise
