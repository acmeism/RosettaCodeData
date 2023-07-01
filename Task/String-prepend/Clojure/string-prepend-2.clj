(def s (atom "World"))
(swap! s #(str "Hello, " %))

user=> @s
user=> "Hello, Wolrd"
