sub postfix:<!> (Int $n) { ( constant factorial = 1, 1, |[\*] 2..* )[$n] }
sink 10000!; # prime the iterator to allow multithreading

sub zs ($n) { ( constant zero-share = (^Inf).race(:32batch).map: { (.!.comb.Bag){'0'} / .!.chars } )[$n+1] }

.say for (
     100
    ,1000
    ,10000
).map:  -> \n { "{n}: {([+] (^n).map: *.&zs) / n}" }
