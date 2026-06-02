keys: [a b c]
vals: [1 2 3]
data: #[]
forall keys [data/(keys/1): vals/(index? keys)]
probe data ;== #[a: 1 b: 2 c: 3]

;; or
size: length? keys
data: make map! size
repeat i size [put data keys/:i vals/:i]
probe data ;== #[a: 1 b: 2 c: 3]
