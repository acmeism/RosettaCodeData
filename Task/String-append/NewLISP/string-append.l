(setq str "foo")

(push "bar" str -1)
; or as an alternative introduced in v.10.1
(extend str "bar")

(println str)
