;;; return all the words that start with an initial letter

(defun filter-with-init (words init)
  (remove-if-not (lambda (word) (eql init (aref word 0))) words))

;;; produce a hash table whose key is the initial letter of a word and whose value is
;;; a list of the words that start with that initial letter

(defun group-by-first-letter (words)
  (let ((map_letters (make-hash-table))
        (inits (remove-duplicates (mapcar (lambda (word) (aref word 0)) words))))
    (dolist (init inits map_letters)
      (setf (gethash init map_letters) (filter-with-init words init)))
    ))

;;; Get the last letter in a word or array

(defun last-element (array) (aref array (- (length array) 1)))

;;; Produce a hash table whose key is a word and whose value is a list of the
;;; words that can follow that word

(defun get-followers (words)
  (let ((map-word-to-followers (make-hash-table :test 'equal))
        (init_hash (group-by-first-letter words)))
    (dolist (word words map-word-to-followers)
      (setf
       (gethash word map-word-to-followers)
       (gethash (last-element word) init_hash)))))

;;; Retrieve all the keys from a hash table

(defun keys (hashtbl)
  (let ((allkeys ()))
    (maphash #'(lambda (key val) (setf allkeys (cons key allkeys))) hashtbl)
    allkeys))

;;; Find the words which can follow a word and haven't been used yet.  The parameters are:
;;;    word - word being tested
;;;    followers - the hash table returned from get-followers
;;;    available - hash table with word as key and boolean indicating whether that word
;;;                has been used previously as value

(defun get-available-followers (word followers available)
  (if (null word)
      (keys followers)
      (remove-if-not #'(lambda (word) (gethash word available)) (gethash word followers))))

;;; Find the best in a list using an arbitrary test

(defun best (lst test)
  (let ((top (car lst)))
    (do
        ((rest (cdr lst) (cdr rest)))
        ((null rest) top)
      (if (funcall test (car rest) top) (setf top (car rest))))))

;;; Find the best path in a list

(defun best-list-path (paths)
  (best paths #'(lambda (path1 path2) (> (length path1) (length path2)))))

;;; Find the best path given all the supporting information we need

(defun best-path-from-available (word followers available depth path available-followers)
  (let ((results
         (mapcar #'(lambda (new-word)
                   (dfs-recurse new-word followers available (+ 1 depth) (cons word path)))
           available-followers)))
    (best-list-path results)))

;;; Recurse to find the best available path - the meat of the algorithm

(defun dfs-recurse (word followers available depth path)
  (let ((ret))
    ; Mark the word as unavailable
    (setf (gethash word available) nil)

    ; Find the longest path starting with word
    (let ((available-followers (get-available-followers word followers available)))
        (setf ret
         (if (null available-followers)
             (cons word path)
           (best-path-from-available word followers available depth path available-followers))))

    ; Mark the word as available again
    (setf (gethash word available) t)

    ; Return our longest path
    ret))

;;; Create the availability table

(defun make-available-table (words)
  (let
      ((available (make-hash-table)))
    (dolist (word words available) (setf (gethash word available) t))))

;;; Find the best path for a set of words

(defun best-path (words)
  (let
      ((followers (get-followers words))
       (available (make-available-table words)))
    (cdr (reverse (dfs-recurse nil followers available 0 nil)))))

;;; set up the words as a set of strings
(setf *words* (mapcar #'symbol-name
'(audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask)))

(setf *path* (best-path *words*))
