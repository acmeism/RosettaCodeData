> "abc" == "abc"
True
> "abc" /= "abc"
False
> "abc" <= "abcd"
True
> "abc" <= "abC"
False
> "HELLOWORLD" == "HelloWorld"
False
> :m +Data.Char
> map toLower "ABC"
"abc"
> map toLower "HELLOWORLD" == map toLower "HelloWorld"
True
