(capi:prompt-for-integer "Enter an integer:"
                         :ok-check #'(lambda (n) (= n 75000)))
