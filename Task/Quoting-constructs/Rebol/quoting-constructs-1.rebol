foreach code [
    "1 + 1"                     ;; A plain string containing the text: 1 + 1
    {reduce ["1 + 1 =" 1 + 1]}  ;; A string that, when loaded, will evaluate and build a block: ["1 + 1 =" 2]
    %{now}%                     ;; A raw string containing the text: now
][
    ;; PRINT outputs a sequence of values:
    ;;   code              -> the raw value being iterated over
    ;;   "-->"             -> a literal string arrow
    ;;   mold do code      -> DO evaluates 'code' as Rebol code.
    ;;                        MOLD converts the result into a textual representation
    print [code "-->" mold do code]
]
