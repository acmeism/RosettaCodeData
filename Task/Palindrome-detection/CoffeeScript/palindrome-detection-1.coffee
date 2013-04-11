isPalindrome = (str) ->
  stripped = str.toLowerCase().replace /\W/g, ""
  stripped == (stripped.split "").reverse().join ""
