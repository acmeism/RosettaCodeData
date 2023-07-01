on run
  intercalate(".", splitOn(",", "Hello,How,Are,You,Today"))
end run


-- splitOn :: String -> String -> [String]
on splitOn(strDelim, strMain)
  set {dlm, my text item delimiters} to {my text item delimiters, strDelim}
  set lstParts to text items of strMain
  set my text item delimiters to dlm
  return lstParts
end splitOn

-- intercalate :: String -> [String] -> String
on intercalate(strText, lstText)
  set {dlm, my text item delimiters} to {my text item delimiters, strText}
  set strJoined to lstText as text
  set my text item delimiters to dlm
  return strJoined
end intercalate
