;; Using Rebol3!
data: #[user: "Rebol" pass: "qwerty"]
;; or from block
data: make map! [user: "Rebol" pass: "qwerty"]
;; to append key...
data/age: 23
print ["User" data/user "has password:" data/pass "and age:" data/age]
;; to remove key...
remove/key data 'age ;== #[user: "Rebol" pass: "qwerty"]
;; retrieving not existing key returns none
data/not-exists      ;== #(none)
;; to test if key exists...
did find data 'user  ;== #(true)
did find data 'xxxx  ;== #(false)
;; to get number of keys:
length? data         ;== 2
;; to get keys...
keys-of data         ;== [user pass]
;; to get values...
values-of data       ;== ["Rebol" "qwerty"]
;; to clear the map...
clear data           ;== #[]

;; keys may be any value type
append data ["a" 1 "b" 2] ;== #["a" 1 "b" 2]
;; when used key with same name multiple times...
append data ["b" 3 "b" 4] ;== #["a" 1 "b" 4]
