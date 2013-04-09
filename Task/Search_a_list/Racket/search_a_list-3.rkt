(define haystack '("Zig" "Zag" "Wally" "Ronald" "Bush" "Krusty" "Charlie" "Bush" "Bozo"))

(for/list ([needle '("Bender" "Bush")])
    (index haystack needle))

(for/list ([needle '("Bender" "Bush")])
    (index-last haystack needle))
