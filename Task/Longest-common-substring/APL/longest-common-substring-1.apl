lcs←{
    sb←∪⊃,/{⌽¨,\⌽⍵}¨,\⍵
    match←(sb(∨/⍷)¨⊂⍺)/sb
    ⊃((⌈/=⊢)≢¨match)/match
}
