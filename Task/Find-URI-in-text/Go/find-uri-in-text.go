package main

import (
    "fmt"
    "github.com/glenn-brown/golang-pkg-pcre/src/pkg/pcre"
)

var pattern =
    "(*UTF)(*UCP)" +                    // Make \w unicode aware
    "[a-z][-a-z0-9+.]*:" +              // Scheme...
    "(?=[/\\w])" +                      // ... but not just the scheme
    "(?://[-\\w.@:]+)?" +               // Host
    "[-\\w.~/%!$&'()*+,;=]*" +          // Path
    "(?:\\?[-\\w.~%!$&'()*+,;=/?]*)?" + // Query
    "(?:\\#[-\\w.~%!$&'()*+,;=/?]*)?"   // Fragment

func main() {
    text := `
this URI contains an illegal character, parentheses and a misplaced full stop:
http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
")" is handled the wrong way by the mediawiki parser.
ftp://domain.name/path(balanced_brackets)/foo.html
ftp://domain.name/path(balanced_brackets)/ending.in.dot.
ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
leading junk ftp://domain.name/path/embedded?punct/uation.
leading junk ftp://domain.name/dangling_close_paren)
if you have other interesting URIs for testing, please add them here:
http://www.example.org/foo.html#includes_fragment
http://www.example.org/foo.html#enthält_Unicode-Fragment
`
    descs := []string{"URIs:-", "IRIs:-"}
    patterns := []string{pattern[12:], pattern}
    for i := 0; i <= 1; i++ {
        fmt.Println(descs[i])
        re := pcre.MustCompile(patterns[i], 0)
        t := text
        for {
            se := re.FindIndex([]byte(t), 0)
            if se == nil {
                break
            }
            fmt.Println(t[se[0]:se[1]])
            t = t[se[1]:]
        }
        fmt.Println()
    }
}
