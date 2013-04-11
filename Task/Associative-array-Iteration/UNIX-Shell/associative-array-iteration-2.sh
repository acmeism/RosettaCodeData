typeset -A a
a=(key1 value1 key2 value2)

# just keys
print -l -- ${(k)a}

# just values
print -l -- ${(v)a}

# keys and values
printf '%s => %s\n' ${(kv)a}
