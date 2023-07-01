fun isBalanced s = checkBrackets 0 (String.explode s)
and checkBrackets 0 [] = true
  | checkBrackets _ [] = false
  | checkBrackets ~1 _ = false
  | checkBrackets counter (#"["::rest) = checkBrackets (counter + 1) rest
  | checkBrackets counter (#"]"::rest) = checkBrackets (counter - 1) rest
  | checkBrackets counter (_::rest) = checkBrackets counter rest
