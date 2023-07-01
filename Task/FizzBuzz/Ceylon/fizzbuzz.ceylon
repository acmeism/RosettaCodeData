shared void run() => {for (i in 1..100) {for (j->k in [3->"Fizz", 5->"Buzz"]) if (j.divides(i)) k}.reduce(plus) else i}.each(print);
