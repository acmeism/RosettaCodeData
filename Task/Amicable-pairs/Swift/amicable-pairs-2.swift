import func Darwin.sqrt

func sqrt(x:Int) -> Int { return Int(sqrt(Double(x))) }

func sigma(n: Int) -> Int {

    if n == 1 { return 0 }          // definition of aliquot sum

    var result = 1
    let root = sqrt(n)

    for var div = 2; div <= root; ++div {
        if n % div == 0 {
            result += div + n/div
        }

    }
    if root*root == n { result -= root }

    return (result)
}

func amicables (upTo: Int) -> () {

    var aliquot = Array(count: upTo+1, repeatedValue: 0)

    for i in 1 ... upTo {           // fill lookup array
        aliquot[i] = sigma(i)
    }

 for i in 1 ... upTo {
        let a = aliquot[i]
        if a > upTo {continue}      //second part of pair out-of-bounds

        if a == i {continue}        //skip perfect numbers

        if i == aliquot[a] {
            print("\(i, a)")
            aliquot[a] = upTo+1     //prevent second display of pair
        }
    }
}

amicables(20_000)
