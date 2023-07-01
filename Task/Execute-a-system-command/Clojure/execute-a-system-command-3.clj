user=> (use '[clojure.java.shell :only [sh]])

user=> (println (:out (sh "cowsay" "Printing a command-line output")))

 _________________________________
< Printing a command-line output. >
 ---------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

nil
