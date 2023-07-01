(random-seed "albert")
(random) → 0.9672510261922906 ; random float in [0 ... 1[
(random 1000)  → 726  ; random integer in [0 ... 1000 [
(random -1000) → -936 ; random integer in ]-1000 1000[

(lib 'bigint)
(random 1e200) → 48635656441292641677...3917639734865662239925...9490799697903133046309616766848265781368
