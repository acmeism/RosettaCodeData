$ awk '{gsub(/[A-Z]/,"*");print}'
abCDefG
ab**ef*
$ awk '{gsub(/[A-Z]/,"(&)");print}'
abCDefGH
ab(C)(D)ef(G)(H)
