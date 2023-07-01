def tests:
  (
    "banana",
    "appellee",
    "dogwood",
    "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
    "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
    "\u0002ABC\u0003"
  )
  | . as $test
  | bwt as $t
  | "\(makePrintable)\n --> \($t | makePrintable
      // "ERROR: String can't contain STX or ETX" )",
    (if $t then " --> \($t | ibwt)\n" else "" end) ;

tests
