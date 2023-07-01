(require '[clojure.java.shell :as shell])
(shell/sh "echo" "foo") ; evaluates to {:exit 0, :out "foo\n", :err ""}
