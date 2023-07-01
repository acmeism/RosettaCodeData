;; init table
(define goodies
          '((map 9 150) ; 9 is weight, 150 is value
            (compass 13 35) (water 153 200) (sandwich 50 160)
            (glucose 15 60) (tin 68 45)(banana 27 60) (apple 39 40)
            (fromage 23 30) (beer 52 10) (🌞-suntan-cream 11 70) (camera 32 30)
            (T-shirt 24 15) (pantalons 48 10) (umbrella 73 40)
            (☔️-trousers 42 70) (☔️-overclothes 43 75) (note-case 22 80)
            (🌞-sun-glasses 7 20) (towel 18 12) (socks 4 50) (book 30 10)))
(list->table goodies T)


(task 400)
total-value     1030
    → (socks 🌞-sun-glasses note-case ☔️-overclothes ☔️-trousers 🌞-suntan-cream banana
    glucose sandwich water compass map)


(length (hash-keys H))
   → 4939  ;; number of entries "i | weight" in hash table
