(dolist (system '(:xpath :cxml-stp :cxml))
  (asdf:oos 'asdf:load-op system))

(defparameter *doc* (cxml:parse-file "xml" (stp:make-builder)))

(xpath:first-node (xpath:evaluate "/inventory/section[1]/item[1]" *doc*))

(xpath:do-node-set (node (xpath:evaluate "/inventory/section/item/price/text()" *doc*))
  (format t "~A~%" (stp:data node)))

(defun node-array (node-set)
  (coerce (xpath:all-nodes node-set) 'vector))

(node-array
 (xpath:evaluate "/inventory/section/item/name" *doc*))
