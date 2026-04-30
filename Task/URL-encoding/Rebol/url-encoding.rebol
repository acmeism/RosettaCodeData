Rebol [
    title: "Rosetta code: URL encoding"
    file:  %URL_encoding.r3
    url:   https://rosettacode.org/wiki/URL_encoding
]

task-except: charset [#"0"-#"9" #"A"-#"Z" #"a"-#"z"]
RFC-3986:    charset [#"0"-#"9" #"A"-#"Z" #"a"-#"z" "-._~"]
js-except:   charset [#"0"-#"9" #"A"-#"Z" #"a"-#"z" "-._~;,/?:@&=+$!*'()#"]

foreach src [
    "http://foo bar/"
    "https://rosettacode.org/wiki/URL_encoding"
    "https://en.wikipedia.org/wiki/Pikes Peak granite"
][
    probe src
    print ["enhex:     " enhex src]
    print ["enhex/uri: " enhex/uri src]
    print ["RFC-3986:  " enhex/except src RFC-3986]
    print ["Custom:    " enhex/except src task-except]
    print ["JavaScript:" enhex/except src js-except]
    print ""
]
