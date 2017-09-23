import macros, strutils

macro toIntVal(s: static[string]): untyped =
  result = parseExpr(s)

proc `/`(x,y:int64): float = return (x.float / y.float)

const
  strInt32 = ["-(-2147483647-1)",
              "2_000_000_000 + 2_000_000_000",
              "-2147483647 - 2147483647",
              "46341 * 46341",
              "(-2147483647-1) / -1"]
  shouldBInt32 = ["2147483648",
                  "4000000000",
                  "-4294967294",
                  "2147488281",
                  "2147483648"]
  strInt64 = ["-(-9_223372_036854_775807-1) ",
              "5_000000_000000_000000+5_000000_000000_000000",
              "-9_223372_036854_775807 - 9_223372_036854_775807",
              "3037_000500 * 3037_000500",
              "(-9_223372_036854_775807-1) / -1"]
  shouldBInt64 = ["9223372036854775808",
                  "10000000000000000000",
                  "-18446744073709551614",
                  "9223372037000250000",
                  "9223372036854775808"]
  strUInt32 = ["-4294967295",
              "3000_000000 +% 3000_000000",
              "2147483647 -% 4294967295",
              "65537 *% 65537"]
  shouldBUInt32 = ["-4294967295",
                  "6000000000",
                  "-2147483648",
                  "4295098369"]
  strUInt64 = ["-18446744073709551615",
               "10_000000_000000_000000 +% 10_000000_000000_000000",
               "9_223372_036854_775807 -% 18_446744_073709_551615",
               "4294967296 * 4294967296",
               "4294967296 *% 4294967296",]  # testing * and *%
  shouldBUInt64 = ["-18446744073709551615",
                   "20000000000000000000",
                   "-9223372036854775808",
                   "18446744073709551616",
                   "18446744073709551616"]
#
# use compile time macro to convert string expr to numeric value
#
var
  resInt32: seq[string] = @[$toIntVal(strInt32[0]),
                         $toIntVal(strInt32[1]),
                         $toIntVal(strInt32[2]),
                         $toIntVal(strInt32[3]),
                         $toIntVal(strInt32[4])]

  resInt64: seq[string] = @[$toIntVal(strInt64[0]),
                         $toIntVal(strInt64[1]),
                         $toIntVal(strInt64[2]),
                         $toIntVal(strInt64[3]),
                         $toIntVal(strInt64[4])]

  resUInt32: seq[string] = @[$toIntVal(strUInt32[0]),
                         $toIntVal(strUInt32[1]),
                         $toIntVal(strUInt32[2]),
                         $toIntVal(strUInt32[3])]

  resUInt64: seq[string] = @["18446744073709551615 out of valid range",
                         "10_000000_000000_000000 out of valid range",
                         "18_446744_073709_551615 out of valid range",
                         $toIntVal(strUInt64[3]),
                         $toIntVal(strUInt64[4])]

proc main() =
  # output format:
  #
  #   stringExpr -> calculatedValueAsAString (expectedValueAsAString)
  echo "-- INT32 --"
  for i in 0..<resInt32.len:
    echo align(strInt32[i], 35), " -> ", align($resInt32[i], 15), " (", $shouldBInt32[i],")"

  echo "-- INT64 --"
  for i in 0..<resInt64.len:
    echo align(strInt64[i], 55), " -> ", align($resInt64[i], 25), " (", $shouldBInt64[i],")"

  echo "-- UINT32 --"
  for i in 0..<resUInt32.len:
    echo align(strUInt32[i], 35), " -> ", align($resUInt32[i], 20), " (", $shouldBUInt32[i],")"

  echo "-- UINT64 --"
  for i in 0..<resUInt64.len:
    echo align(strUInt64[i], 55), " -> ", align($resUInt64[i], 42), " (", $shouldBUInt64[i],")"

main()
