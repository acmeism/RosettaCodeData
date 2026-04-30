Rebol [
    title: "Rosetta code: URL decoding"
    file:  %URL_decoding.r3
    url:   https://rosettacode.org/wiki/URL_decoding
]

foreach [src expected] [
    "http%3A%2F%2Ffoo%20bar%2F"
    "http://foo bar/"

    "google.com/search?q=%60Abdu%27l-Bah%C3%A1"
    "google.com/search?q=`Abdu'l-Bahá"

    "%25%32%35"
    "%25"
][

    probe src
    probe url: dehex src
    print either expected = url ["OK"]["FAILED!"]
    print ""
]
