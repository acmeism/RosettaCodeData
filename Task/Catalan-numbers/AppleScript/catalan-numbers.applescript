set catalan to 1
repeat with n from 1 to 15
  log catalan as integer
  set catalan to 2 * (2 * n - 1) * catalan / (n + 1)
end repeat
