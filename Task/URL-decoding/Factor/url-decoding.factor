USING: io kernel urls.encoding ;
IN: rosetta-code.url-decoding

"http%3A%2F%2Ffoo%20bar%2F"
"google.com/search?q=%60Abdu%27l-Bah%C3%A1"
[ url-decode print ] bi@
