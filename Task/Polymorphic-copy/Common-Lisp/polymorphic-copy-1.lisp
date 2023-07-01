(defstruct super foo)

(defstruct (sub (:include super)) bar)

(defgeneric frob (thing))

(defmethod frob ((super super))
  (format t "~&Super has foo = ~w." (super-foo super)))

(defmethod frob ((sub sub))
  (format t "~&Sub has foo = ~w, bar = ~w."
          (sub-foo sub) (sub-bar sub)))
