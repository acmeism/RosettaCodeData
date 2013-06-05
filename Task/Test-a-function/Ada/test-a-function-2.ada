   function Palindrome (Text : String) return Boolean
     with Post => Palindrome'Result =
     (Text'Length < 2 or else
	((Text(Text'First) = Text(Text'Last)) and then
	   Palindrome(Text(Text'First+1 .. Text'Last-1))));
