string uritext = #"this URI contains an illegal character, parentheses and a misplaced full stop:
http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer).
which is handled by http://mediawiki.org/).
and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
\")\" is handled the wrong way by the mediawiki parser.
ftp://domain.name/path(balanced_brackets)/foo.html
ftp://domain.name/path(balanced_brackets)/ending.in.dot.
ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
leading junk ftp://domain.name/path/embedded?punct/uation.
leading junk ftp://domain.name/dangling_close_paren)
if you have other interesting URIs for testing, please add them here:";

array find_uris(string uritext)
{
    array uris=({});
    int pos=0;
    while((pos = search(uritext, ":", pos+1))>0)
    {
        int prepos = sizeof(array_sscanf(reverse(uritext[pos-20..pos-1]), "%[a-zA-Z0-9+.-]%s")[0]);
        int postpos = sizeof(array_sscanf(uritext[pos+1..], "%[^\n\r\t <>\"]%s")[0]);

        if ((<'.',',','?','!',';'>)[uritext[pos+postpos]])
            postpos--;
        if (uritext[pos-prepos-1]=='(' && uritext[pos+postpos]==')')
            postpos--;
        if (uritext[pos-prepos-1]=='\'' && uritext[pos+postpos]=='\'')
            postpos--;
        uris+= ({ uritext[pos-prepos..pos+postpos] });
    }
    return uris;
}

find_uris(uritext);
Result: ({ /* 11 elements */
            "stop:",
            "http://en.wikipedia.org/wiki/Erich_K\303\244stner_(camera_designer)",
            "http://mediawiki.org/)",
            "parser:",
            "http://en.wikipedia.org/wiki/-)",
            "ftp://domain.name/path(balanced_brackets)/foo.html",
            "ftp://domain.name/path(balanced_brackets)/ending.in.dot",
            "ftp://domain.name/path(unbalanced_brackets/ending.in.dot",
            "ftp://domain.name/path/embedded?punct/uation",
            "ftp://domain.name/dangling_close_paren)",
            "here:"
        })
