   getWords=: (' '&splitstring) :. (' '&joinstring)
   reverseString=: |.
   reverseWords=: |.&.>&.getWords
   reverseWordOrder=: |.&.getWords
