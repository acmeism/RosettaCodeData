import Base.-

""" overload - operator on vectors to return new vector from which all == subelem element are removed """
-(vec, subelem) where T =  [elem for elem in vec if elem != subelem]

""" overload - operator on strings to return new string from which all == char c are removed """
-(s::String, c::Char) = String([ch for ch in s if ch != c])

@show [2, 3, 4, 3, 1, 7] - 3    # [2, 3, 4, 3, 1, 7] - 3 = [2, 4, 1, 7]
@show "world" - 'o'             # "world" - 'o' = "wrld"
