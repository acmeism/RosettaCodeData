; uiop is part of the de facto build system, asdf, so should be available to most installations.

; synchronous
(uiop:run-program "ls")

; async
(defparameter *process* (uiop:launch-program "ls"))
(uiop:wait-process *process*)
