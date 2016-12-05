import string
def caesar(s, k = 13, decode = False, *, memo={}):
  if decode: k = 26 - k
  k = k % 26
  table = memo.get(k)
  if table is None:
    table = memo[k] = str.maketrans(
                        string.ascii_uppercase + string.ascii_lowercase,
                        string.ascii_uppercase[k:] + string.ascii_uppercase[:k] +
                        string.ascii_lowercase[k:] + string.ascii_lowercase[:k])
  return s.translate(table)
