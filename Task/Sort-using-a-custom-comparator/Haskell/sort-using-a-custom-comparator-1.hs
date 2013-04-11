import List
import Char

mycmp s1 s2 = case compare (length s2) (length s1) of
                 EQ -> compare (map toLower s1) (map toLower s2)
                 x  -> x

strings = ["Here", "are", "some", "sample", "strings", "to", "be", "sorted"]
sorted = sortBy mycmp strings
