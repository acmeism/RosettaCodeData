put display (^∞).map(1 ~ *).race.map( -> \n { next unless [eq] (2,3,4,5,6).map: { (n × $_).comb.sort.join }; n } ).first;

sub display ($n) { join "\n", " n: $n", (2..6).map: { "×$_: {$n×$_}" } }
