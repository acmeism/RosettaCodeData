def testcases: [1668, 1990, 2008, 2020, 4444, 5000, 8999, 39999, 89999, 399999];

"Decimal => Roman:",
 (testcases[]
  | "   \(.) => \(to_roman_numeral)" )
