proc stripLineComments {inputString {commentChars ";#"}} {
    # Switch the RE engine into line-respecting mode instead of the default whole-string mode
    regsub -all -line "\[$commentChars\].*$" $inputString "" commentStripped
    # Now strip the whitespace
    regsub -all -line {^[ \t\r]*(.*\S)?[ \t\r]*$} $commentStripped {\1}
}
