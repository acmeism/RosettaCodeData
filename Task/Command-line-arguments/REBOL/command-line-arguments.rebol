Rebol [
    title: "Rosetta code: Command-line arguments"
    file:  %Command-line_arguments.r3
    url:   https://rosettacode.org/wiki/Command-line_arguments
]

;; write a throwaway script that prints args
write %temp-script.r3 {Rebol [] probe system/options/args}

;; launch it as a subprocess, passing sample CLI args; /wait blocks until done
call/shell/wait {rebol3 temp-script.r3 --args -c "alpha beta" -h gamma}

delete %temp-script.r3  ;; clean up
