(use 'clojure.test)

(deftest test-palindrome?
  (is (palindrome? "amanaplanacanalpanama"))
  (is (not (palindrome? "Test 1, 2, 3")))

(run-tests)
