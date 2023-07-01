(with-open [r (io/reader "input.txt")]
  (doseq [line (line-seq r)]
    (send writer write-line line)))
(await writer)
(println "lines written:" @writer)
(shutdown-agents)
