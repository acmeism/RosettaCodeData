import BigInt

func modPow<T: BinaryInteger>(n: T, e: T, m: T) -> T {
  guard e != 0 else {
    return 1
  }

  var res = T(1)
  var base = n % m
  var exp = e

  while true {
    if exp & 1 == 1 {
      res *= base
      res %= m
    }

    if exp == 1 {
      return res
    }

    exp /= 2
    base *= base
    base %= m
  }
}

let a = BigInt("2988348162058574136915891421498819466320163312926952423791023078876139")
let b = BigInt("2351399303373464486466122544523690094744975233415544072992656881240319")

print(modPow(n: a, e: b, m: BigInt(10).power(40)))
