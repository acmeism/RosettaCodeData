def test(f, good, bad):
  assert all(f(x) for x in good)
  assert not any(f(x) for x in bad)
  print '%s passed all %d tests' % (f.__name__, len(good)+len(bad))

pals = ('', 'a', 'aa', 'aba', 'abba')
notpals = ('aA', 'abA', 'abxBa', 'abxxBa')
for ispal in is_palindrome, is_palindrome_r, is_palindrome_r2:
  test(ispal, pals, notpals)
