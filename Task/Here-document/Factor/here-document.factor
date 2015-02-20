"    a multiline
string\n(with escape sequences: \u{greek-capital-letter-sigma})
"
"""this is "easier".."""
HEREDOC: EOF
             this
 is not \n escaped at all
EOF
