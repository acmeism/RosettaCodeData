def sumDigits(x:BigInt, base:Int=10):BigInt=sumDigits(x.toString(base), base)
def sumDigits(x:String, base:Int):BigInt = x map(_.asDigit) sum
