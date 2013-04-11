is_palindrome_r x | length x <= 1 = True
                  | head x == last x = is_palindrome_r . tail. init $ x
                  | otherwise = False
