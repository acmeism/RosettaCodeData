function Palindrome (Text : String) return Boolean is
(for all i in Text'Range => Text(i)= Text(Text'Last-i+Text'First));
