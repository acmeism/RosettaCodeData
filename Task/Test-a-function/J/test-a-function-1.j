NB. Contents of palindrome_test.ijs

NB. Basic testing
test_palinA=: monad define
  assert isPalin0 'abcba'
  assert isPalin0 'aa'
  assert isPalin0 ''
  assert -. isPalin0 'ab'
  assert -. isPalin0 'abcdba'
)

NB. Can test for expected failure instead
palinB_expect=: 'assertion failure'
test_palinB=: monad define
  assert isPalin0 'ab'
)
