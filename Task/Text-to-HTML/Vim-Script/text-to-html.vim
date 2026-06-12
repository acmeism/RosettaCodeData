" Substitute the XML predefined character entities
%s/&\ze\([^A-z#]\)/\&amp;/g
%s/>/\&gt;/g
%s/</\&lt;/g
%s/"/\&quot;/g
%s/'/\&apos;/g
" Substitute URIs: presumes ! $ & ' ( ) * + , ; = : will be %xx escaped
%s/http[s]\?:\/\/[A-z0-9._~:/-]\+\ze[^.:]/<a href="\0">\0<\/a>
" Substitute simple tables, which use tabs (U+0009)
%s/\([^\t]\+\t.\+\n\n\?\)\+/<table>\r\0<\/table>\r/
%s/\([^\t]\+\t.\+\n\n\?\)\+/<thead>\0<\/tbody>/
%s/\(<thead>\)\(.\+\)/\1\r<tr>\2<\/tr>\r<\/thead>\r<tbody>/
%s/^\([^<][^\t]\+\t.\+\)\n\n\?\(<\/tbody>\)/<tr>\1<\/tr>\r\2\r/
%s/^\([^<][^\t]\+\t.\+\)\n\n\?/<tr>\1<\/tr>\r/
%s/<tr>\zs.*\ze<\/tr>/\=substitute(submatch(0), '\t', '<\/td><td>', 'g')/g
%s/<tr>/&<td>/
%s/<\/tr>/<\/td>&/
" Substitute the unordered list items, and temporarily precede them with <!--ulx-->
%s/* \(.\+\)\n\n*/<!--ulx--><li>\1<\/li>\r/
" Substitute the ordered list items, and temporarily precede them with <!--olx-->
%s/\d[.] \(.\+\)\n\n*/<!--olx--><li>\1<\/li>\r/
" Clean up <!--olx--> contiguous lines, wrapping them in <ol>
%s/\(<!--olx--><li>.\+\n\)\+/<ol>\r&<\/ol>\r/
" Clean up <!--ulx--> contiguous lines, wrapping them in <ul>
%s/\(<!--ulx--><li>.\+\n\)\+/<ul>\r&<\/ul>\r/
" Clean up <!--?lx--> - remove the placeholder comment
%s/<!--.lx-->//g
" Add the XML declaration, XHTML strict DOCTYPE, <head> and <title> block (with <script> and CSS for the tables), putting the text within <title>...</title>
1s/\s\+\(.\+\)\n\n\?/<\?xml version="1.0" encoding="UTF-8"\?>\r<!DOCTYPE html PUBLIC "-\/\/W3C\/\/DTD XHTML 1.0 Strict\/\/EN" "http:\/\/www.w3.org\/TR\/xhtml1\/DTD\/xhtml1-strict.dtd">\r<html xmlns="http:\/\/www.w3.org\/1999\/xhtml" xml:lang="en" lang="en">\r<head><title>\1<\/title>\r<style type="text\/css">\rh1, h2 { font-weight: bold; text-align: center; }\rtable, th, td { border: 1px solid black; }\r<\/style>\r<\/head>\r<body>\r<h1>\1<\/h1>\r/
" Substitute paragraphs starting with space+ A-Z and wrap within a <h2>...</h2>
%s/^\s\+\([A-Z].\+\)\n/<h2>\1<\/h2>\r/
" Substitute paragraphs starting with A-Z and wrap within a <p>...</p>
%s/^\([A-Z].\+\)\n/<p>\1<\/p>\r/
" Add the </body> and </html> to the end of the buffer
$s/\n/&<\/body>\r<\/html>/
" Substitute double returns with single returns
%s/\n\n/\r/
" Write the file and quit Vim
wq!
