def Item($name; $value; $weight; $volume):
  {$name, $value, $weight, $volume};

def items:[
    Item("panacea"; 3000; 0.3; 0.025),
    Item("ichor"; 1800; 0.2; 0.015),
    Item("gold"; 2500; 2; 0.002)
];

def array($init): [range(0; .) | $init];

# input: {count, best, bestvalue}
def knapsack($i; $value; $weight; $volume):
  (items|length) as $n
  | if $i == $n
    then if $value > .bestValue
         then .bestValue = $value
         | reduce range(0; $n) as $j (.; .best[$j] = .count[$j])
         else .
	 end
    else (($weight / items[$i].weight)|floor) as $m1
    | (($volume / items[$i].volume)|floor) as $m2
    | .count[$i] = ([$m1, $m2] | min)
    | until (.count[$i] < 0;
        knapsack(
            $i + 1;
            $value  + .count[$i] * (items[$i].value);
            $weight - .count[$i] * (items[$i].weight);
            $volume - .count[$i] * (items[$i].volume)
        )
        | .count[$i] += -1
    )
    end ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def solve($maxWeight; $maxVolume):

  def rnd: 100 * . | round / 100;

  def rnd($width): if type == "string" then lpad($width) else rnd|lpad($width) end;

  def f(a;b;c;d;f):
     "\(a|lpad(11)) \(b|rnd(6)) \(c|rnd(6)) \(d|rnd(6)) \(f|rnd(6))" ;

  def f: . as [$a,$b,$c,$d,$f] | f($a;$b;$c;$d;$f);

  (items|length) as $n
  | def init:
     { count: ($n|array(0)),
       best : ($n|array(0)),
       bestValue: 0,
       maxWeight: $maxWeight,
       maxVolume: $maxVolume };

  f("Item Chosen"; "Number"; "Value"; "Weight"; "Volume"),
  "----------- ------ ------ ------ ------",
  ( init
    | knapsack(0; 0; $maxWeight; $maxVolume)
    | reduce range(0; $n) as $i (
        . + {itemCount:0, sumNumber:0, sumWeight:0, sumVolume:0 };
        if (.best[$i]) != 0
        then .itemCount  += 1
        | .name   = items[$i].name
        | .number = .best[$i]
        | .value  = items[$i].value  * .number
        | .weight = items[$i].weight * .number
        | .volume = items[$i].volume * .number
        | .sumNumber  += .number
        | .sumWeight  +=  .weight
        | .sumVolume  +=  .volume
	| .emit += [ f(.name; .number; .value; .weight; .volume) ]
        else .
        end)
    | .emit[],
      "----------- ------ ------ ------ ------",
      f(.itemCount; .sumNumber; .bestValue; .sumWeight; .sumVolume) );

solve(25; 0.25)
