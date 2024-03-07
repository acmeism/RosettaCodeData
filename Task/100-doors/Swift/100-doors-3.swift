var arr: [Bool] = Array(1...100).map{ remquo(exp(log(Float($0))/2.0),1).0 == 0 }
