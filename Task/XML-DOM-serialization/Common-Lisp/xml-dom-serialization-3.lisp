(defun append-child* (parent &rest children)
  (reduce 'dom:append-child children :initial-value parent))

(let* ((doc (dom:create-document 'rune-dom:implementation nil nil nil)))
  (append-child* doc
                 (dom:create-element doc "root")
                 (dom:create-element doc "element")
                 (dom:create-text-node doc "Some text here"))
  (write-string (dom:map-document (cxml:make-rod-sink) doc)))
