func grayEncode(_ i: Int) -> Int {
  return (i >> 1) ^ i
}

func grayDecode(_ i: Int) -> Int {
  switch i {
  case 0:
    return 0
  case _:
    return i ^ grayDecode(i >> 1)
  }
}

for i in 0..<32 {
  let iStr = String(i, radix: 2)
  let encode = grayEncode(i)
  let encodeStr = String(encode, radix: 2)
  let decode = grayDecode(encode)
  let decodeStr = String(decode, radix: 2)

  print("\(i) (\(iStr)) => \(encode) (\(encodeStr)) => \(decode) (\(decodeStr))")
}
