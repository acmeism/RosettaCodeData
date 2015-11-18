//Remove everything except for letters and digits and convert the string to lowercase. source is what will be compared to str.
var str = string_lower(string_lettersdigits(string_replace(argument0," ",""))), source = "";

//Loop through and store each character of str in source.
for (var i = string_length(str); i > 0; i--) {
    source += string_char_at(str,i);
}

//Return if it is a palindrome.
return source == str;
