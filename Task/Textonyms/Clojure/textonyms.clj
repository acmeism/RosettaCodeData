(def table
  {\a 2 \b 2 \c 2       \A 2 \B 2 \C 2
   \d 3 \e 3 \f 3       \D 3 \E 3 \F 3
   \g 4 \h 4 \i 4       \G 4 \H 4 \I 4
   \j 5 \k 5 \l 5       \J 5 \K 5 \L 5
   \m 6 \n 6 \o 6       \M 6 \N 6 \O 6
   \p 7 \q 7 \r 7 \s 7  \P 7 \Q 7 \R 7 \S 7
   \t 8 \u 8 \v 8       \T 8 \U 8 \V 8
   \w 9 \x 9 \y 9 \z 9  \W 9 \X 9 \Y 9 \Z 9})

(def words-url "http://www.puzzlers.org/pub/wordlists/unixdict.txt")

(def words (-> words-url slurp clojure.string/split-lines))

(def digits (partial map table))

(let [textable  (filter #(every? table %) words) ;; words with letters only
      mapping   (group-by digits textable)       ;; map of digits to words
      textonyms (filter #(< 1 (count (val %))) mapping)] ;; textonyms only
  (print
   (str "There are " (count textable) " words in " \' words-url \'
        " which can be represented by the digit key mapping. They require "
        (count mapping) " digit combinations to represent them. "
        (count textonyms) " digit combinations represent Textonyms.")))
