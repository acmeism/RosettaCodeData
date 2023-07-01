[ 'GB82 WEST 1234 5698 7654 32',
  'GB82 TEST 1234 5698 7654 32',
  'GB81 WEST 1234 5698 7654 32',
  'SA03 8000 0000 6080 1016 7519',
  'CH93 0076 2011 6238 5295 7' ].each { iban ->
    println "$iban is ${validateIBAN(iban) ? 'valid' : 'invalid'}"
}
