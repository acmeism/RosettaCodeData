(let [search (future (shell/sh "find" "." "-name" "needle.*" :dir haystack))]
  (while (and (other-stuff-to-do?) (not (future-done? search)))
    (do-other-stuff))
  (let [{:keys [exit out err]} @search]
    (if (zero? exit)
      (do-something-with out)
      (report-errors-in err))))
