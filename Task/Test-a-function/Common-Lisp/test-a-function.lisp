(defpackage :rosetta
  (:use :cl
        :fiveam))
(in-package :rosetta)

(defun palindromep (string)
  (string= string (reverse string)))

;; A suite of tests are declared with DEF-SUITE
(def-suite palindrome-suite :description "Tests for PALINDROMEP")

;; Tests following IN-SUITE are in the defined suite of tests
(in-suite palindrome-suite)

;; Tests are declared with TEST and take an optional documentation
;; string
(test palindromep
  "Basic unit tests for PALINDROMEP."
  (is-true (palindromep "a"))
  (is-true (palindromep ""))
  (is-true (palindromep "aba"))
  (is-true (palindromep "ahha"))
  (is-true (palindromep "amanaplanacanalpanama"))
  (is-false (palindromep "ab"))
  (is-false (palindromep "abcab")))

(test palindromep-bad-tests
  "In order to demonstrate a failing test"
  (is-true (palindromep "ab")))

;; Property based tests are also possible using built-in generators
(test matches-even-length-palindromes
  (for-all ((s (gen-string)))
    (is-true (palindromep (concatenate 'string s (reverse s))))))

;; And counter examples can be found for failing tests. This also
;; demonstrates combining generators to create cleaner input, in this
;; case restricting characters to the range of ASCII characters and
;; only permitting alphanumeric values.
(test matches-even-length-palindromes-bad
  (for-all ((s (gen-string :elements (gen-character :code (gen-integer :min 0 :max 127) :alphanumericp t))))
    (is-true (palindromep (concatenate 'string s s)))))

#|
Tests can be executed using RUN, RUN!, and (EXPLAIN! result-list)

RUN! = (EXPLAIN! (RUN test))

Individual tests can be run or the entire suite:

ROSETTA> (run! 'palindrome-suite)

Running test suite PALINDROME-SUITE
 Running test PALINDROMEP .......
 Running test PALINDROMEP-BAD-TESTS f
 Running test MATCHES-EVEN-LENGTH-PALINDROMES .....................................................................................................
 Running test MATCHES-EVEN-LENGTH-PALINDROMES-BAD ff
 Did 10 checks.
    Pass: 8 (80%)
    Skip: 0 ( 0%)
    Fail: 2 (20%)

 Failure Details:
 --------------------------------
 MATCHES-EVEN-LENGTH-PALINDROMES-BAD []:
      Falsifiable with ("oMYhcqnVbjYgxT6d3").
 Results collected with failure data:
    Did 1 check.
       Pass: 0 ( 0%)
       Skip: 0 ( 0%)
       Fail: 1 (100%)

    Failure Details:
    --------------------------------
    MATCHES-EVEN-LENGTH-PALINDROMES-BAD []:
         (PALINDROMEP (CONCATENATE 'STRING S S)) did not return a true value.
    --------------------------------

 --------------------------------
 --------------------------------
 PALINDROMEP-BAD-TESTS [In order to demonstrate a failing test]:
      (PALINDROMEP "ab") did not return a true value.
 --------------------------------

NIL
(#<IT.BESE.FIVEAM::TEST-FAILURE {10083B52A3}>
 #<IT.BESE.FIVEAM::FOR-ALL-TEST-FAILED {1008B34963}>)
NIL
ROSETTA> (run! 'palindromep)

Running test PALINDROMEP .......
 Did 7 checks.
    Pass: 7 (100%)
    Skip: 0 ( 0%)
    Fail: 0 ( 0%)

T
NIL
NIL
|#
