Rebol [
    title: "Rosetta code: Find unimplemented tasks"
    file:  %Rosetta_Code-Find_unimplemented_tasks.r3
    url:   https://rosettacode.org/wiki/Rosetta_Code/Find_unimplemented_tasks
    needs: 3.20.0 ;; rosettacode.org serves only over TLS1.3 and higher
]

API-URL: https://rosettacode.org/w/api.php
do-query: function[query cont][
    try/with [
        if cont [query: ajoin [query "&cmcontinue=" cont] ]
        url: join API-URL query
        decode 'json read url
    ][
        print ["Failed to read URL:" url]
        none
    ]
]
fetch-category: function [category][
    members: copy []
    query: ajoin [
        "?action=query&list=categorymembers&format=json"
        "&cmlimit=500&cmtitle=Category:" :category
    ]
    cmcontinue: none
    forever [
        all [
            data: do-query :query :cmcontinue
            append members data/query/categorymembers
        ]
        either data/continue [
            cmcontinue: data/continue/cmcontinue
        ][  break ]
    ]
    members
]
tasks: function [language [any-string! none!]][
    ;; Keep only task titles; ignore category pages
    data: fetch-category any [language "Programming_Tasks"]
    forall data [
        title: data/1/title
        either find/match title "Category:" [
            data: back remove data
        ][  change data title ]
    ]
    data
]
num: func[blk][as-green pad length? blk 4]

system/options/quiet: true
print ["At this moment:" as-yellow now ]

all-tasks: tasks none ;= all tasks
print ["There is" num all-tasks "tasks"]
reb-tasks: tasks "Rebol"
reb-drafts: exclude reb-tasks all-tasks
print ["There is" num reb-tasks "Rebol solutions including drafts:" num reb-drafts]
unimplemented: difference all-tasks reb-tasks
print ["There is" num unimplemented "unimplemented tasks in Rebol language"]

;; Compare with another language:
red-tasks: tasks "Red"
print ["There is" num red-tasks "Red solutions"]
print ["There is" num exclude red-tasks reb-tasks "tasks implemented in Red but not in Rebol language"]
print ["There is" num exclude reb-tasks red-tasks "tasks implemented in Rebol but not in Red language"]
