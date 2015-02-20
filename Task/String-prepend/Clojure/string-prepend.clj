(def s (ref "World"))
(dosync (alter s #(str "Hello " %)))

user=> @s
"Hello World"
