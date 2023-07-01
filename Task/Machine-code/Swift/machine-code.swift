import Foundation

typealias TwoIntsOneInt = @convention(c) (Int, Int) -> Int

let code = [
  144, // Align
  144,
  106, 12, // Prepare stack
  184, 7, 0, 0, 0,
  72, 193, 224, 32,
  80,
  139, 68, 36, 4, 3, 68, 36, 8, // Rosetta task code
  76, 137, 227, // Get result
  137, 195,
  72, 193, 227, 4,
  128, 203, 2,
  72, 131, 196, 16, // Clean up stack
  195, // Return
] as [UInt8]

func fudge(x: Int, y: Int) -> Int {
  let buf = mmap(nil, code.count, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANON, -1, 0)

  memcpy(buf, code, code.count)

  let fun = unsafeBitCast(buf, to: TwoIntsOneInt.self)
  let ret = fun(x, y)

  munmap(buf, code.count)

  return ret
}

print(fudge(x: 7, y: 12))
