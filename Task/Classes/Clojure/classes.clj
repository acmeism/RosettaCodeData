; You can think of this as an interface
(defprotocol Foo (getFoo [this]))

; Generates Example1 Class with foo as field, with method that returns foo.
(defrecord Example1 [foo] Foo (getFoo [this] foo))

; Create instance and invoke our method to return field value
(-> (Example1. "Hi") .getFoo)
"Hi"
