;; Let's Create a tool [a function] that helps us check positive integers
;; to see which one's square is the first one that ends in ...269696
;; It should be noted that a function can be used many times repetitively
;; so let's create that function which will be used many times.

;; First, define the function, give it a name and parameters; it will look like:
;; (defun [function_name] ([input_parameter] / [local_variables])
(defun SquareEndsWith269696? (number / )
  ;; Let's have the computer Square the number (whichever number was passed to the function)
  (setq number (* number number))
  ;; Now let's convert that number to a string
  (setq numberString (itoa number))
  ;; Is the length of the numberString greater than or equal to 6 digits?
  (if (>= (strlen numberString) 6)
    ;; If it was greater than or equal to 6, we will check the last 6 characters to see if they are equal to "269696"
    ;; If this equality check is successful, then we have found our number, and will return a successful function check!
    (eq "269696" (substr numberString (- (strlen numberString) 5)))
    ;; Otherwise, an unsuccessful function check will be returned
  )
)

;; Second, we will create a function that only needs to be used once, they do not always need to be used many times
;; Let's use your name as the initiator/name for this function
(defun c:BABBAGE ( / integer SquareFound)
  ;; Once we have initiated the function, let's create our first integer to check
  (setq integer 1)
  ;; Now, let's perform a loop do perform an action many times within the function
  ;; We do not want our loop to run infinitely, so let's create a True/False variable to identify if our task is complete
  (setq SquareFound nil)
  ;; ok, let's use the loop and True/False variable to continually check if we have found our correct integer
  (while (not SquareFound)
    ;; Now within the loop, let's use our First function to check if we have the correct integer
    ;; We will save the new result of our check over our existing True/False variable
    (setq SquareFound (SquareEndsWith269696? integer))
    ;; If the square was not found...
    (if (not SquareFound)
      ;; ...increase our integer number by 1
      (setq integer (1+ integer))
    )
    ;; Once the integer is found, our loop will end and the code will continue forward
    ;; Otherwise, it will start back at "(while ..."
  )
  ;; If we have made it this far, then our integer has been found!
  ;; let's show everyone what the integer is
  (prompt
    (strcat
      "\nThe smallest integer has been found!"
      "\nInteger: " (itoa integer) ;; <-- we are converting the integer to a string
      "\nSquared: " (itoa (* integer integer)) ;; <-- let's show everyone the squared number to prove it
    )
  )
  ;; All done, this last line is not required, but makes the ending cleaner
  (princ)
)
