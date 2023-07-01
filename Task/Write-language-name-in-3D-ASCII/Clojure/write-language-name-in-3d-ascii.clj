(use 'clj-figlet.core)
(println
  (render-to-string
    (load-flf "ftp://ftp.figlet.org/pub/figlet/fonts/contributed/larry3d.flf")
    "Clojure"))
