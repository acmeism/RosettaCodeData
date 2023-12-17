(var object       {:a 1 :b "Hello, world!" [1 2 3] :c}
     serialised   (to-json object)
     deserialised (from-json serialised))

(print "Object:       " object)
(print "Serialised:   " serialised)
(str "Deserialised: " deserialised)
