Rebol [
    title: "Rosetta code: Here document"
    file:  %Here_document.r3
    url:   https://rosettacode.org/wiki/Here_document
]

;; Rebol supports multi-line strings with curly braces {..}
;; Newlines and indentation are preserved as-is
print {
    There were sharp pains,
        and sudden dizziness,
            and then profuse bleeding at the pores,
                with dissolution.
}

print "----"

;; In Rebol3 %{..}% is a raw string literal (heredoc-style)
;; unlike {..}, it allows unescaped } and { inside without escaping
print %%{
    This is a "raw string literal," using %{..}%
        roughly equivalent to a heredoc.
    It can contain unescaped parens like: }{}
}%%
