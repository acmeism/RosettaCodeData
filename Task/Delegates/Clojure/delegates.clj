(defprotocol Thing
  (thing [_]))

(defprotocol Operation
  (operation [_]))

(defrecord Delegator [delegate]
  Operation
  (operation [_] (try (thing delegate) (catch IllegalArgumentException e "default implementation"))))

(defrecord Delegate []
  Thing
  (thing [_] "delegate implementation"))
