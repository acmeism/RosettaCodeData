def backToBig(num: String, oldBase: Int): BigInt = BigInt(num, oldBase)

def bigToBase(num: BigInt, newBase: Int): String = num.toString(newBase)
