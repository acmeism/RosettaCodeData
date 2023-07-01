$ awk 'BEGIN{c="x"; s="hello";s1 = "abcd"; s2 = "ab\"cd"; s=s c; print s; print s1; print s2}'
hellox
