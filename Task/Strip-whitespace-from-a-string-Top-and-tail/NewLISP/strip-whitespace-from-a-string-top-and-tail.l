(setq str "   this is a string   ")

;; trim leading blanks
(trim str " " "")

;; trim trailing blanks
(trim str "" " ")

;; trim both leading and trailing blanks
(trim str)
