(def s (ref "World"))
(dosync (alter s #(str "Hello " %)))

user=> @s
user=> "Hello World"
