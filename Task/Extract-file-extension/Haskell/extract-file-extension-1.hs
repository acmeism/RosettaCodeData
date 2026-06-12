module FileExtension
   where

myextension :: String -> String
myextension s
   |not $ elem '.' s = ""
   |elem '/' extension || elem '_' extension = ""
   |otherwise = '.' : extension
      where
	 extension = reverse ( takeWhile ( /= '.' ) $ reverse s )
