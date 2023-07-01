#  Item {name, weight, value, count}

def Item($name; $weight; $value; $count): {$name, $weight, $value, $count};

def items: [
    Item("map"; 9; 150; 1),
    Item("compass"; 13; 35; 1),
    Item("water"; 153; 200; 2),
    Item("sandwich"; 50; 60; 2),
    Item("glucose"; 15; 60; 2),
    Item("tin"; 68; 45; 3),
    Item("banana"; 27; 60; 3),
    Item("apple"; 39; 40; 3),
    Item("cheese"; 23; 30; 1),
    Item("beer"; 52; 10; 3),
    Item("suntan cream"; 11; 70; 1),
    Item("camera"; 32; 30; 1),
    Item("T-shirt"; 24; 15; 2),
    Item("trousers"; 48; 10; 2),
    Item("umbrella"; 73; 40; 1),
    Item("waterproof trousers"; 42; 70; 1),
    Item("waterproof overclothes"; 43; 75; 1),
    Item("note-case"; 22; 80; 1),
    Item("sunglasses"; 7; 20; 1),
    Item("towel"; 18; 12; 2),
    Item("socks"; 4; 50; 1),
    Item("book"; 30; 10; 2)
];

def knapsack($w):
  def list($init): [range(0; .) | $init];
  (items|length) as $n
  | {m: ($n+1 | list( $w + 1 | list(0) )) }
  | reduce range(1; $n+1) as $i (.;
      reduce range (0; $w + 1) as $j (.;
            .m[$i][$j] = .m[$i-1][$j]
	    | label $out
            | foreach (range(1; 1 + ((items[$i - 1].count))), null) as $k (.stop = false;
	          if $k == null then .
		  elif ($k * items[$i - 1].weight > $j) then .stop = true
                  else (.m[$i - 1][$j - ($k * items[$i - 1].weight)] + $k * items[$i - 1].value) as $v
                  | if $v > .m[$i][$j] then .m[$i][$j] = $v else . end
		  end;
		if .stop or ($k == null)  then ., break $out else empty end)
            ) )
  | .s = ($n|list(0))
  | .j = $w
  | reduce range($n; 0; -1) as $i (.;
        .m[$i][.j] as $v
        | .k = 0
        | until ($v == .m[$i - 1][.j] + .k * items[$i - 1].value;
            .s[$i - 1] +=  1
            | .j = .j - items[$i - 1].weight
            | .k += 1 ) )
    | .s;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task(maxWeight):
  def f(a;b;c;d): "\(a|lpad(22)) \(b|lpad(6)) \(c|lpad(6)) \(d|lpad(6))";
  def f: . as [$a,$b,$c,$d] | f($a;$b;$c;$d);

  (items|length) as $n
  | knapsack(maxWeight) as $s
  | f("Item Chosen";          "Weight";"Value";"Number"),
    "---------------------- ------  ----- ------",
   ({ itemCount:0,
      sumWeight:0,
      sumValue :0,
      sumNumber:0 }
    | reduce range(0; $n) as $i (.;
        if ($s[$i] != 0)
        then .itemCount += 1
        | .name   = items[$i].name
        | .number = $s[$i]
        | .weight = items[$i].weight * .number
        | .value  = items[$i].value  * .number
        | .sumNumber  += .number
        | .sumWeight  += .weight
        | .sumValue   += .value
	| .emit += [[.name, .weight, .value, .number]]
	else .
	end )
    | (.emit[] | f),
    "---------------------- ------  ----- ------",
     f("Items chosen \(.itemCount|lpad(4))"; .sumWeight; .sumValue; .sumNumber) );

task(400)
