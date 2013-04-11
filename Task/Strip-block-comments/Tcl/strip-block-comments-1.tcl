proc stripBlockComment {string {openDelimiter "/*"} {closeDelimiter "*/"}} {
    # Convert the delimiters to REs by backslashing all non-alnum characters
    set openAsRE [regsub -all {\W} $openDelimiter {\\&}]
    set closeAsRE [regsub -all {\W} $closeDelimiter {\\&}]

    # Now remove the blocks using a dynamic non-greedy regular expression
    regsub -all "$openAsRE.*?$closeAsRE" $string ""
}
