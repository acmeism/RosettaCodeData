=+  big=(pow 5 (pow 4 (pow 3 2)))
=+  digits=(lent (skip <big> |=(a/* ?:(=(a '.') & |))))
[digits (div big (pow 10 (sub digits 20))) (mod big (pow 10 20))]
