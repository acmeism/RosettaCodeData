Rebol [
    title: "Rosetta code: Rosetta_Code/Count_examples"
    file:  %Rosetta_Code-Count_examples.r3
    url:   https://rosettacode.org/wiki/Rosetta_Code/Count_examples
]

;; Import caching and HTML decoding utilities
import thru-cache
import html-entities

;; Set HTTPS request timeout to 30 seconds
system/schemes/https/spec/timeout: 30

get-all-task-titles: function [
    "Scrapes all Rosetta Code task titles"
][
    ;; Build the base API URL for querying the Programming Tasks category
    base-url: rejoin [
        https://rosettacode.org/w/api.php
        "?action=query&format=xml&list=categorymembers&cmlimit=500"
        "&cmtitle=Category:Programming_Tasks"
    ]
    que: to block! base-url ;; Initialize queue with the starting URL
    titles: copy []         ;; Will hold task titles as [pageid title]

    ;; Process each URL in the queue (handles pagination across subcategory pages)
    while [not empty? que][
        ;; Dequeue and read the next URL
        url: take que
        print ["Reading:" as-blue find/tail url "&cmtitle="]
        xml: read-thru/string url

        cmcontinue: none ;; Will hold the "next page" subcategory token, if present
        parse xml [
            ;; Try to extract the pagination continuation token
            opt [
                thru {<continue cmcontinue="}
                copy cmcontinue: to #"^""
            ]
            thru <categorymembers>
            ;; Extract pageid and title from each <cm> element
            any [
                thru {<cm pageid="} copy pageid: to #"^""
                thru { title="} copy title: to #"^""
                (
                    ;; Store pageid as integer alongside title
                    repend titles [to integer! pageid title]
                )
            ]
        ]
        ;; If a cmcontinue token was found, enqueue the continuation URL
        if cmcontinue [
            append que rejoin [base-url "&cmcontinue=" cmcontinue]
        ]
    ]
    titles
]

get-task-examples: function[
    "Return language names with solution for a given task"
    task
][
    ;; Decode HTML entities and re-encode for use in a URL
    task: enhex decode 'html-entities task
    url: join https://rosettacode.org/w/index.php?action=raw&title= task
    data: read-thru/string url
    ;; Collect all language header names from the raw wiki markup
    parse data [
        collect any [thru "=={{header|" keep to "}}=="]
    ]
]

;; Fetch all task titles from Rosetta Code
titles: get-all-task-titles

;; Count language examples per task
counts: make block! length? titles
foreach [pageid title] titles [
    try/with [
        langs: get-task-examples title
        num: length? langs
        print [title as-green num]
        ;; Store [count title] pairs for later sorting
        repend counts [num title]
    ] :print  ;; On error, print the error and continue
]

;; Sort by example count, descending
sort/skip/reverse counts 2

;; Display the 10 tasks with the most language examples
print as-yellow "^/Top 10 tasks with the most examples:"
loop 10 [
    print [counts/2 "has" counts/1 "examples."]
    counts: skip counts 2
]

;; Seek to the last 20 entries (10 pairs) to find the least-covered tasks
print as-yellow "^/Top 10 tasks with the minimum examples:"
counts: skip tail counts -20
loop 10 [
    print [counts/2 "has" counts/1 "examples."]
    counts: skip counts 2
]

;; Timestamp when the data fetch completed
print ["^/Data received:" as-green now]

;; Optionaly clear all localy stored pages
;  clear-thru/only https://rosettacode.org/*
