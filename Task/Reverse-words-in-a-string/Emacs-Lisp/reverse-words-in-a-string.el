(defun reverse-words (line)
  (insert
   (format "%s\n"
           (mapconcat 'identity (reverse (split-string line)) " "))))

(defun reverse-lines (lines)
  (mapcar 'reverse-words lines))

(reverse-lines
 '("---------- Ice and Fire ------------"
   ""
   "fire, in end will world the say Some"
   "ice. in say Some"
   "desire of tasted I've what From"
   "fire. favor who those with hold I"
   ""
   "... elided paragraph last ..."
   ""
   "Frost Robert ----------------------- "))
