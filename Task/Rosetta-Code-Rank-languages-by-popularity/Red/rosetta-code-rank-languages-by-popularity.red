Red []

data: read http://www.rosettacode.org/mw/index.php?title=Special:Categories&limit=5000
lb: make block! 500
;;data: read %data.html ;; for testing save html and use flat file
arr: split data newline

k: "Category:"
;; exclude list:
exrule: [thru ["programming"
                | "users"
                | "Implementations"
                | "Solutions by "
                | "Members"
                | "WikipediaSourced"
                | "Typing/Strong"
                | "Impl needed"
                ]
            to end
          ]

foreach line arr [
  unless find line k [continue]
  parse line [ thru k thru ">" copy lang to "<" to end ] ;; extract/parse language
  if 20 < length? lang [continue]
  if parse lang [exrule] [continue] ;; exclude invalid
  cnt: 0
  ;; parse number of entries
  parse line [thru "</a>" thru "(" copy cnt  to " member" (cnt: to-integer cnt ) to end]
  if cnt > 25 [  append  lb reduce [to-string lang cnt]   ] ;; only process lang with > 25 entries
]

lb:  sort/skip/compare lb 2 2   ;; sort series by entries

print reduce [ "Rank Entries Language" ]    ;; header

last: 0
rank: 0

lb: tail lb   ;; process the series backwards

until [
  lb: skip lb -2
  cnt: second lb
  if cnt <> last [
    rank: rank + 1
  ]
  print rejoin [ pad/left rank 4 "." pad/left cnt 5 " - " first lb  ]
  last: cnt
  head? lb  ;; until head reached
]
