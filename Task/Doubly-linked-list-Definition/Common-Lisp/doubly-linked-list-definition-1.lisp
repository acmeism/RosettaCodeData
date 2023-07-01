(defstruct dlist head tail)
(defstruct dlink content prev next)

(defun insert-between (dlist before after data)
  "Insert a fresh link containing DATA after existing link BEFORE if not nil and before existing link AFTER if not nil"
  (let ((new-link (make-dlink :content data :prev before :next after)))
    (if (null before)
        (setf (dlist-head dlist) new-link)
        (setf (dlink-next before) new-link))
    (if (null after)
        (setf (dlist-tail dlist) new-link)
        (setf (dlink-prev after) new-link))
    new-link))

(defun insert-before (dlist dlink data)
  "Insert a fresh link containing DATA before existing link DLINK"
  (insert-between dlist (dlink-prev dlink) dlink data))

(defun insert-after (dlist dlink data)
  "Insert a fresh link containing DATA after existing link DLINK"
  (insert-between dlist dlink (dlink-next dlink) data))

(defun insert-head (dlist data)
  "Insert a fresh link containing DATA at the head of DLIST"
  (insert-between dlist nil (dlist-head dlist) data))

(defun insert-tail (dlist data)
  "Insert a fresh link containing DATA at the tail of DLIST"
  (insert-between dlist (dlist-tail dlist) nil data))

(defun remove-link (dlist dlink)
  "Remove link DLINK from DLIST and return its content"
  (let ((before (dlink-prev dlink))
        (after (dlink-next dlink)))
    (if (null before)
        (setf (dlist-head dlist) after)
        (setf (dlink-next before) after))
    (if (null after)
        (setf (dlist-tail dlist) before)
        (setf (dlink-prev after) before))))

(defun dlist-elements (dlist)
  "Returns the elements of DLIST as a list"
  (labels ((extract-values (dlink acc)
             (if (null dlink)
                 acc
                 (extract-values (dlink-next dlink) (cons (dlink-content dlink) acc)))))
    (reverse (extract-values (dlist-head dlist) nil))))
