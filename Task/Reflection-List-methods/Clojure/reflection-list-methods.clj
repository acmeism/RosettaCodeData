; Including listing private methods in the clojure.set namespace:
=> (keys (ns-interns 'clojure.set))
(union map-invert join select intersection superset? index bubble-max-key subset? rename rename-keys project difference)

; Only public:
=> (keys (ns-publics 'clojure.set))
(union map-invert join select intersection superset? index subset? rename rename-keys project difference)
