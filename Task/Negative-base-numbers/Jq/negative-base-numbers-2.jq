def negbase($b):
  if ($b >= 0) then error("negbase requires negative base")
  elif . == 0 then "0"
  else {n: ., ans: ""}
  | until(.n == 0;
         .r = ((.n % $b))
  	 | .n = ((.n / $b) | trunc)
         | if .r < 0 then .n += 1 | .r -= $b else . end
         | .ans = (.r|tostring) + .ans )
  | .ans
  end ;

def sigma(stream): reduce stream as $x (null; .+$x);

def invnegbase($b):
  (explode | reverse | map(. - 48)) as $s
  | sigma( range(0; $s|length) | ($s[.] * pow($b; .)));

def testset: {
   "11110": [10, -2],
   "21102": [146, -3],
   "195":   [15, -10]
 };

def test: testset
| to_entries[]
| .value[0] as $n
| .value[1] as $base
| ($n|negbase($base)) as $neg
| ($neg | invnegbase($base)) as $invneg
| [.key == $neg, $n == $invneg]
;

test
