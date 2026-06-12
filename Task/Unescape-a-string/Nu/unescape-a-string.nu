def unescape [] {
  $'"($in)"' | from json -s
}

# test
[
  'abc'
  'a☺c'
  'a\"c'
  '\u0061\u0062\u0063'
  'a\\c'
  'a\u263Ac'
  'a\\u263Ac'
  'a\uD834\uDD1Ec'
  'a\ud834\udd1ec'
  'a"c'
  'a\u263'
  'a\u263Xc'
  'a\uDD1Ec'
  'a\uD834c'
  'a\uD834\u263Ac'
]
| each {
  {input: $in result: ($in | try { unescape } catch { '<error>' })}
}
