(defconst articulation-1 '("b" "f" "p" "v" "B" "F" "P" "V"))

(defconst articulation-2 '("c" "g" "j" "k" "q" "s" "x" "z" "C" "G" "J" "K" "Q" "S" "X" "Z"))

(defconst articulation-3 '("d" "t" "D" "T"))

(defconst articulation-4 '("l" "L"))

(defconst articulation-5 '("m" "n" "M" "N"))

(defconst articulation-6 '("r" "R"))

(defconst vowel '("a" "e" "i" "o" "u" "A" "E" "I" "O" "U"))

(defconst semi-vowels '("h" "w" "y" "H" "W" "Y"))

(defun drop-vowels (str)
  "Keep first letter, drop a, e, i, o, u."
  (let ((first-letter (substring str 0 1))
        (string-minus-first-letter (substring str 1)))
    (concat first-letter (replace-regexp-in-string "[aeiou]" "" string-minus-first-letter))))

(defun drop-semi-vowels (str)
  "Keep first letter, drop h, w, y."
  (let ((first-letter (substring str 0 1))
        (string-minus-first-letter (substring str 1)))
    (concat first-letter (replace-regexp-in-string "[hwy]" "" string-minus-first-letter))))

(defun drop-repeated-adjacent-consonants (str)
  "Drop repeated adjacent consonants with same Soundex number."
  (let ((current-letter)
        (next-letter)
        (current-soundex-number)
        (next-soundex-number)
        (modified-word str)
        (position-in-word 0))
    (condition-case nil
        (while (substring modified-word position-in-word (+ 2 position-in-word))
          (setq current-letter (substring modified-word position-in-word (1+ position-in-word)))
          (setq next-letter (substring modified-word (1+ position-in-word) (+ position-in-word 2)))
          (setq current-soundex-number (get-soundex-number current-letter))
          (setq next-soundex-number (get-soundex-number next-letter))
          (when (and
                 (equal current-soundex-number next-soundex-number)
                 (member current-soundex-number '("1" "2" "3" "4" "5")))
            (setq modified-word (replace-regexp-in-string (concat current-letter next-letter) current-letter modified-word)))
          (setq position-in-word (1+ position-in-word)))
      (error nil))
    modified-word))

(defun get-soundex-number (letter)
  "Get the Soundex number of LETTER.
LETTER should be a string of just one letter.
Soundex numbers are numbers 1-6.
If the letter is a vowel or y, h, or w, there is
no Soundex number, so get an 8 for a vowel or a 9
for y, y, or w."
  (cond ((member letter articulation-1) "1")
        ((member letter articulation-2) "2")
        ((member letter articulation-3) "3")
        ((member letter articulation-4) "4")
        ((member letter articulation-5) "5")
        ((member letter articulation-6) "6")
        ((member letter vowel)          "8")
        ((member letter semi-vowel)     "9")))

(defun soundex-all-but-first-letter (str)
  "Converts STR to Soundex except for first letter.
For this function to work correctly, vowels and
h, w, and y must have already been removed.
Also, certain consonants must have already been
removed per the Soundex processing rules."
  (let ((word-position 0)
        (current-letter)
        (converted-word "")
        (converted-character "")
        (word-length (length str)))
    (while (< word-position word-length)
      (setq current-letter (substring str word-position (1+ word-position)))
      (if (> word-position 0)
          (setq converted-character (get-soundex-number current-letter))
        (setq converted-character current-letter))
      (setq word-position (1+ word-position))
      (setq converted-word (concat converted-character converted-word)))
    (setq converted-word (reverse converted-word))
    (setq word-length (length converted-word))
    (cond ((= word-length 4)
           converted-word)
          ((> word-length 4)
           (substring converted-word 0 4))
          ((< word-length 4)
           (let* ((difference (- 4 word-length))
                  (pad ""))
             (dotimes (_ difference)
               (setq pad (concat "0" pad)))
             (concat converted-word pad))))))

(defun soundex-word (str)
  "Code STR to Soundex.
This function applies all the steps needed
to code STR into the correct Soundex code."
  (let ((converted-word str))
    (setq converted-word (drop-repeated-adjacent-consonants converted-word))
    (setq converted-word (drop-semi-vowels converted-word))
    (setq converted-word (drop-repeated-adjacent-consonants converted-word))
    (setq converted-word (drop-vowels converted-word))
    (setq converted-word (soundex-all-but-first-letter converted-word))
    converted-word))
