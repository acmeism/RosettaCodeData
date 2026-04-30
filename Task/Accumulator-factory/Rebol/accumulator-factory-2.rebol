;; Define a generator function 'gen' with an optional refinement '/init'
;; - 'value' is a required number passed to the function
;; - '/init' is an optional refinement for initialization
gen: function/with [value [number!] /init] [

    ;; If '/init' refinement is used, initialize state and exit immediately
    if init [
        state: value    ;; Set the initial state to the provided value
        exit            ;; Exit, so nothing else in the function is run
    ]

    ;; If not initializing, add 'value' to 'state'
    state: state + value

    ;; The function returns the new state each call
][state: 0]             ;; 'state' is a local variable, initialized once per definition (persistent closure)

;; Initialize the 'state' value of gen to 1 by calling it with '/init'
gen/init 1

;; Call gen with 5: Adds 5 to state and prints the result (should print 6)
print gen 5

;; Call gen with 2.3: Adds 2.3 to state and prints the result (should print 8.3)
print gen 2.3
