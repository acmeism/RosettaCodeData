Rebol [
    title: "Rosetta code: JSON pointer"
    file:  %JSON_pointer.r3
    url:   https://rosettacode.org/wiki/JSON_pointer
]

get-json-pointer: function[
    data [map!]   "Decoded JSON data"
    ptr [string!] "JSON pointer"
][
    if empty? ptr    [return data]
    if ptr   ==  "/" [return select data ""]
    if ptr/1 != #"/" [do to error! "Invalid JSON pointer!"]
    parts: split next ptr #"/"
    forall parts [
        parse parts/1 [any [to #"~" [
            change "~1" #"/" |
            change "~0" #"~" | skip
        ]]]
        any [
            attempt [change parts to word! parts/1]
            attempt [change parts 1 + to integer! parts/1]
        ]
    ]
    insert parts 'data
    get as path! parts
]


data: decode 'json {{
  "wiki": {
    "links": [
      "https://rosettacode.org/wiki/Rosetta_Code",
      "https://discord.com/channels/1011262808001880065"
    ]
  },
  "": "Rosetta",
  " ": "Code",
  "g/h": "chrestomathy",
  "i~j": "site",
  "abc": ["is", "a"],
  "def": { "": "programming" }
}}

foreach ptr [
    "" "/" "/ " "/abc" "/def/" "/g~1h" "/i~0j"
    "/wiki/links/0" "/wiki/links/1" "/wiki/links/2"
    "/wiki/name" "/no/such/thing" "bad/pointer"
][
    printf [20 "--> "][
        mold ptr
        try/with [mold get-json-pointer data :ptr][ as-red "error!" ]
    ]
]
