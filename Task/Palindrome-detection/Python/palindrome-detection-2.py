def is_palindrome(s):
  low = 0
  high = len(s) - 1
  while low < high:
    if not s[low].isalpha():
      low += 1
    elif not s[high].isalpha():
      high -= 1
    else:
      if s[low].lower() != s[high].lower():
        return False
      else:
        low += 1
        high -= 1
        return True
