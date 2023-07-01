def cube: . * . * .;

def pow3: pow(.; 3);

def benchmark($n; func; $arg; $calls):
  reduce range(0; $n) as $i ([];
    now as $_
    | (range(0; $calls) | ($arg | func)) as $x
      # milliseconds:
      | . +  [(now - $_) * 1000 | floor] ) ;

"Timings (total elapsed time in milliseconds):",
"cube pow3",
([benchmark(10; cube; 5; 1e5), benchmark(10; pow3; 5; 1e5)]
 | transpose[]
 | "\(.[0])   \(.[1])" )
