(for Str '("apples, pears # and bananas" "apples, pears ; and bananas")
   (prinl (car (split (chop Str) "#" ";"))) )
