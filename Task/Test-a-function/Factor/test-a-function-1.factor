USING: kernel sequences ;
IN: palindrome

: palindrome? ( string -- ? ) dup reverse = ;
