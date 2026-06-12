pairs = [[21,15],[17,23],[36,12],[18,29],[60,15]]
pairs.select{|p, q| p.gcd(q) == 1}.each{|pair| p pair}
