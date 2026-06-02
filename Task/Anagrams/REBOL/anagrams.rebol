Rebol [
    title: "Rosetta code: Anagrams"
    file:  %Anagrams.r3
    url:   https://rosettacode.org/wiki/Anagrams
    note: "Based on Red language implementation!"
]
;; Build an anagram index from a local unix dictionary file and print the largest anagram families
m: make map! [] 25000   ;; pre-size a map for better performance (target ~25,000 keys)

;; Ensure unixdict.txt exists locally; if not, download it
unless exists? %unixdict.txt [
    write %unixdict.txt read https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt
]
;; Track the size of the largest anagram group found so far
maxx: 0
;; Read the dictionary line-by-line
foreach word read/lines %unixdict.txt [
    sword: sort copy word                ;; key = sorted letters of the word (anagram signature)
    either find m sword [                ;; if we already have this signature
        append m/:sword word             ;; add the word to that anagram group
        maxx: max maxx length? m/:sword  ;; update maximum group size if needed
    ][                                   ;; otherwise create a new group with this word
        put m sword append copy [] word
    ]
]
;; Print all groups that match the maximum size (i.e., largest anagram families)
foreach [k v] m [
    if maxx = length? v [print v]
]
