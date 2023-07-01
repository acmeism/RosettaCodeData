; Join list of strings into single string, with given separator between elements.
(define string-join
  (lambda (str-lst sep)
    (fold-right (lambda (ele acc) (if (string=? acc "") ele (string-append ele sep acc)))
                ""
                str-lst)))

; Define the output file name and the three records to write to it.
(let ((filename
        "mimic-passwd.txt")
      (record1
        (string-join
          (list
            "jsmith" "x" "1001" "1000"
            (string-join
              '("Joe Smith" "Room 1007" "(234)555-8917" "(234)555-0077" "jsmith@rosettacode.org")
              ",")
            "/home/jsmith" "/bin/bash")
          ":"))
      (record2
        (string-join
          (list
            "jdoe" "x" "1002" "1000"
            (string-join
              '("Jane Doe" "Room 1004" "(234)555-8914" "(234)555-0044" "jdoe@rosettacode.org")
              ",")
            "/home/jdoe" "/bin/bash")
          ":"))
      (record3
        (string-join
          (list
            "xyz" "x" "1003" "1000"
            (string-join
              '("X Yz" "Room 1003" "(234)555-8913" "(234)555-0033" "xyz@rosettacode.org")
              ",")
            "/home/xyz" "/bin/bash")
          ":")))

  ; Write the first two records to the output file.
  ; Replace any existing file.  Lock file for exclusive access.
  (let ((op (open-file-output-port filename
                                   (file-options replace exclusive)
                                   'line
                                   (make-transcoder (latin-1-codec) 'lf))))
    (format op "~a~%" record1)
    (format op "~a~%" record2)
    (close-output-port op))

  ; Append the third record to the output file.
  ; Open existing file keeping contents.  Append to file.  Lock file for exclusive access.
  (let ((op (open-file-output-port filename
                                   (file-options no-fail no-truncate append exclusive)
                                   'line
                                   (make-transcoder (latin-1-codec) 'lf))))
    (format op "~a~%" record3)
    (close-output-port op)))
