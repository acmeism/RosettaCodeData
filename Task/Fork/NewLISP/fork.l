(let (pid (fork (println "Hello from child")))
  (cond
   ((nil? pid) (throw-error "Unable to fork"))
   ('t (wait-pid pid))))
