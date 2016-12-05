local(str = 'The quick grey rhino jumped over the lazy green fox.')

//starting from n characters in and of m length;
#str->substring(16,5) //rhino

//starting from n characters in, up to the end of the string
#str->substring(16) //rhino jumped over the lazy green fox.

//whole string minus last character
#str->substring(1,#str->size - 1) //The quick grey rhino jumped over the lazy green fox

//starting from a known character within the string and of m length;
#str->substring(#str->find('g'),10) //grey rhino

//starting from a known substring within the string and of m length
#str->substring(#str->find('rhino'),12) //rhino jumped
