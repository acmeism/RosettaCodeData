def rFact
rFact = { (it > 1) ? it * rFact(it - 1) : 1 }
