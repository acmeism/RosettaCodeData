;; by increasing entropy

(H "🔴")  → 0
(H "🔵🔴") → 1
(H "1223334444") → 1.8464393446710154
(H "♖♘♗♕♔♗♘♖♙♙♙♙♙♙♙♙♙") → 2.05632607578088
(H "EchoLisp")  → 3
(H "Longtemps je me suis couché de bonne heure") → 3.860828877124944
(H "azertyuiopmlkjhgfdsqwxcvbn") → 4.700439718141092
(H (for/list ((i 1000)) (random 1000)))  → 9.13772704467521
(H (for/list ((i 100_000)) (random 100_000))) → 15.777516877140766
(H (for/list ((i 1000_000)) (random 1000_000))) → 19.104028424596976

