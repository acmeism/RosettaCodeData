Rebol [
    title: "Rosetta code: Rosetta Code/Rank languages by popularity"
    file:  %Rosetta_Code-Rank_languages_by_popularity.r3
    url:   https://rosettacode.org/wiki/Rosetta_Code/Rank_languages_by_popularity
]

get-lang-popularity: function [
    "Scrapes Rosetta Code to rank programming languages by number of task solutions"
][
    base-url: https://rosettacode.org/wiki/Category:Programming_Languages
    que: to block! base-url ;; Initialize queue with the starting URL
    data: copy []           ;; Will hold [language pages language pages ...] pairs

    ;; Process each URL in the queue (handles pagination across subcategory pages)
    while [not empty? que][
        ;; Dequeue and read the next URL
        url: take que
        print ["Reading:" as-blue url]
        html: read/string url

        ;; Truncate the HTML at the page content section we don't need,
        ;; so the parser doesn't accidentally match links in the page footer
        clear find html <div id="mw-pages">

        next-cat: none ;; Will hold the "next page" subcategory token, if present
        parse html [
            ;; Jump to the subcategories section of the page
            thru <div id="mw-subcategories">
            ;; Optionally capture the pagination token for the next batch of subcategories
            opt [
                thru {<a href="/wiki/Category:Programming_Languages?subcatfrom=}
                copy next-cat: to #"^""
            ]
            ;; Iterate over every language subcategory entry on this page
            any [
                thru {<bdi dir="ltr"><a href="}
                copy cat-url: to #"^""
                thru {title="Category:}
                copy cat-ttl: to #"^""
                thru {title="Contains }
                copy contains: to #"^""
                (
                    ;print [pad copy cat-ttl -25 contains]
                    if parse contains [thru ", " copy pages: to SP to end][
                        replace/all pages #"," ""
                        repend data [cat-ttl to integer! pages]
                    ]
                )
            ]
        ]
        ;; If a next-page token was found, enqueue the continuation URL
        if next-cat [
            append que rejoin [base-url %?subcatfrom= next-cat]
        ]
    ]
    ;; Return the sorted [lang pages lang pages ...] block by page count, descending
    sort/skip/compare/reverse data 2 2
]

;; --- Display Top 100 ---
data: get-lang-popularity ;; Fetch and rank all languages
n: 1                      ;; Rank counter
print "Rosetta Code top 100 languages by tasks solved:"
foreach [language pages] data [
    if n > 100 [break]    ;; Stop after the top 100
    ;; Print rank, language name (highlighted), and solution count
    print rejoin [pad n -3 ". " as-yellow language " (" pages ")"]
    ++ n
]
;; Timestamp when the data fetch completed
print ["Data received:" as-green now]
