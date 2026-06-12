typeset -i klarner_rado i m i2=0 i3=0 m2=1 m3=1

for ((i = 0; i < 1000000; ++i))
do
    ((klarner_rado[i] = m = m2 < m3 ? m2 : m3))
    ((m2 == m && (m2 = klarner_rado[i2++] << 1 | 1)))
    ((m3 == m && (m3 = klarner_rado[i3++] * 3 + 1)))
done

print -r -- "${klarner_rado[0..99]}"
for ((i = 1000; i <= ${#klarner_rado[@]}; i *= 10))
do
    print -r -- "${klarner_rado[i - 1]}"
done
