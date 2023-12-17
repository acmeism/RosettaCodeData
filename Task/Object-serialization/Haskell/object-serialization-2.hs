(var object       {:a 1 :b "Hello, world!" [1 2 3] :c}
     serialised   (str object)
     deserialised (safe-eval serialised))

(print "Object:       " object)
(print "Serialised:   " serialised)
(str "Deserialised: " deserialised)
