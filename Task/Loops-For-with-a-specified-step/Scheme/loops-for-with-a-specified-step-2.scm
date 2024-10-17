(let loop ((i 2))            ; function name, parameters and starting values
  (cond ((< i 9)
         (display i)
         (newline)
         (loop (+ i 2))))))  ; tail-recursive call, won't create a new stack frame
