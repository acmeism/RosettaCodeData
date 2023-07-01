fn main() {
    str := "abcdefghijklmnopqrstuvwxyz"
    find_char := "q"
    find_string := "pq"
    n := 12
    m := 5
	
//  starting from n characters in and of m length
    println(str.substr(n - 1, (n - 1) + m))
	
//  starting from n characters in, up to the end of the string	
    println(str.substr(n - 1, str.len))
	
//  whole string minus last character		
    println(str.substr(0, str.len - 1))
	
//  starting from a known character within the string and of m length // returns nothing if not found	
    println(str.substr(str.index(find_char) or {return}, (str.index(find_char) or {return}) + m))
	
//  starting from a known character within the string and of m length // returns nothing if not found
    println(str.substr(str.index(find_string) or {return}, (str.index(find_string) or {return}) + m))
}
