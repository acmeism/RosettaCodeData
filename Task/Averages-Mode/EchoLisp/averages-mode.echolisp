(define (modes L)
	(define G (group* L)) ;; sorts and group equal items
	(define cardmax (for/max [(g G)] (length g)))
	(map first (filter (lambda(g) (= cardmax (length g))) G)))

(modes '( a b c a d e f))
    → (a)
(modes (iota 6))
    → (0 1 2 3 4 5)
(modes '(x))
    → (x)
(modes '(🎾 🏉 ☕️ 🎾 🎲 🎯 🎺 ☕️ 🎲 🎸 🎻 🏆 ☕️ 🏁 🎾 🎲 🎻 🏉 ))
    → (🎾 ☕️ 🎲)

(modes '())
😖️ error: group : expected list : null 🔎 'modes'
