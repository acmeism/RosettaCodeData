def juggler:
  . as $n
  | if $n < 1 then "juggler starting value must be a positive integer." | error
    else { a: $n, count: 0, maxCount: 0, max: $n }
    | until (.a == 1;
        if .a % 2 == 0 then .a |= isqrt
        else .a = ((.a * .a * .a)|isqrt)
        end
        | .count += 1
        | if .a > .max
          then .max = .a
          | .maxCount = .count
	  else .
	  end)
    | [.count, .maxCount, .max, (.max|tostring|length)]
    end
;

def fmt(a;b;c;d):
  "\(.[0]|lpad(a)) \(.[1]|lpad(b)) \(.[2]|lpad(c)) \(.[3]|lpad(d))" ;

def task1:
  "n    l[n]  i[n]                h[n]",
  "-----------------------------------",
  (range(20; 40)
   | . as $n
   | juggler as $res
   | [$n, $res[0], $res[1], $res[2] ]
   | fmt(4;4;4;14) ) ;

def task2:
  def nums:[113, 173, 193, 2183, 11229, 15065, 15845, 30817];

 "   n     l[n]   i[n]     d[n]",
  "-----------------------------",
  (nums[]
   | . as $n
   | juggler as $res
   | [$n, $res[0], $res[1], $res[3] ]
   | fmt(6; 6; 6; 8) );

task1, "", task2
