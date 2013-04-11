$ awk '{gsub(/[A-Z]+/,"(&)");print}'
abCDefGH
ab(CD)ef(GH)
