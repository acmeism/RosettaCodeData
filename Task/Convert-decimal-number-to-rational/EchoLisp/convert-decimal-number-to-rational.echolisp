(exact->inexact 67/74)
   → 0.9054054054054054
(inexact->exact 0.9054054054054054)
   → 67/74

(rationalize 0.7978723404255319)
  → 75/94

;; finding rational approximations of PI
(for ((ε (in-range -1 -15 -1)))
	(writeln ( format "precision:10^%d %t PI = %d" ε
        (rationalize PI (expt 10 e)))))
	
"precision:10^-1                   PI = 16/5"
"precision:10^-2                   PI = 22/7"    ;;🎩
"precision:10^-3                   PI = 201/64"
"precision:10^-4                   PI = 333/106"
"precision:10^-5                   PI = 355/113"  ;; 🎩 🎩
"precision:10^-6                   PI = 355/113"
"precision:10^-7                   PI = 75948/24175"
"precision:10^-8                   PI = 100798/32085"
"precision:10^-9                   PI = 103993/33102"
"precision:10^-10                  PI = 312689/99532"
"precision:10^-11                  PI = 833719/265381"
"precision:10^-12                  PI = 4272943/1360120"
"precision:10^-13                  PI = 5419351/1725033"
"precision:10^-14                  PI = 58466453/18610450"
