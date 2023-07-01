(scl 2)

(de *Data
   ("Lagos"                21.0)
   ("Cairo"                15.2)
   ("Kinshasa-Brazzaville" 11.3)
   ("Greater Johannesburg" 7.55)
   ("Mogadishu"            5.85)
   ("Khartoum-Omdurman"    4.98)
   ("Dar Es Salaam"        4.7)
   ("Alexandria"           4.58)
   ("Abidjan"              4.4)
   ("Casablanca"           3.98) )

(test 6
   (dec (index (assoc "Dar Es Salaam" *Data) *Data)) )

(test "Khartoum-Omdurman"
   (car (find '((L) (> 5.0 (cadr L))) *Data)) )

(test 4.58
   (cadr (find '((L) (pre? "A" (car L))) *Data)) )
