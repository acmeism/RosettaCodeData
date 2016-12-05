;; JSON standard types : strings, numbers, and arrays (vectors)
(export-json #(6 7 8 9))  →   "[6,7,8,9]"
(export-json #("alpha" "beta" "gamma"))  →   "["alpha","beta","gamma"]"

(json-import "[6,7,8,9]")  →   #( 6 7 8 9)
(json-import #<< ["alpha","beta","gamma"] >>#)  →   #( "alpha" "beta" "gamma")

;; EchoLisp types : dates, rational, complex, big int
(export-json 3/4)  →   "{"_instanceof":"Rational","a":3,"b":4}"
(json-import #<< {"_instanceof":"Rational","a":666,"b":42} >>#)  →   111/7

;; Symbols
(export-json 'Simon-Gallubert)  →   "{"_instanceof":"Symbol","name":"Simon-Gallubert"}"
(json-import #<< {"_instanceof":"Symbol","name":"Antoinette-de-Gabolde"} >>#)
    →   Antoinette-de-Gabolde

;; Lists
(define my-list
    (export-json '( 43 4 5 ( 6 7 ( 8 9 )))))
    →    "{"_instanceof":"List" ,"array":[43,4,5,{"_instanceof":"List",
    "array":[6,7,{"_instanceof":"List",
    "array":[8,9],"circular":false}],"circular":false}],"circular":false}"

(json-import my-list)  →   (43 4 5 (6 7 (8 9)))

;; Structures
(struct Person (name pict))  →   #struct:Person [name pict]
(define antoinette (Person "antoinette" "👰"))   →   # (antoinette 👰)

(export-json antoinette)  →
    "{"_instanceof":"Struct", "struct":"Person","id":17,"fields":["antoinette","👰"]}"
(json-import
    #<< {"_instanceof":"Struct","struct":"Person","id":18,"fields":["simon","🎩"]} >>#)
	→   # (simon 🎩)
