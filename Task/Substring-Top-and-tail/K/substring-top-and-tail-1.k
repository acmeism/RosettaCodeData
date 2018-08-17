    s: "1234567890"
"1234567890"
    s _di 0 /Delete 1st character
"234567890"
    s _di -1+#s /Delete last character
"123456789"
    (s _di -1+#s) _di 0 /String with both 1st and last character removed
"23456789"
