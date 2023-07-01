(defstruct huffman-node
  (weight 0 :type number)
  (element nil :type t)
  (encoding nil :type (or null bit-vector))
  (left nil :type (or null huffman-node))
  (right nil :type (or null huffman-node)))

(defun initial-huffman-nodes (sequence &key (test 'eql))
  (let* ((length (length sequence))
         (increment (/ 1 length))
         (nodes (make-hash-table :size length :test test))
         (queue '()))
    (map nil #'(lambda (element)
                 (multiple-value-bind (node presentp) (gethash element nodes)
                   (if presentp
                     (incf (huffman-node-weight node) increment)
                     (let ((node (make-huffman-node :weight increment
                                                    :element element)))
                       (setf (gethash element nodes) node
                             queue (list* node queue))))))
         sequence)
    (values nodes (sort queue '< :key 'huffman-node-weight))))

(defun huffman-tree (sequence &key (test 'eql))
  (multiple-value-bind (nodes queue)
      (initial-huffman-nodes sequence :test test)
    (do () ((endp (rest queue)) (values nodes (first queue)))
      (destructuring-bind (n1 n2 &rest queue-rest) queue
        (let ((n3 (make-huffman-node
                   :left n1
                   :right n2
                   :weight (+ (huffman-node-weight n1)
                              (huffman-node-weight n2)))))
          (setf queue (merge 'list (list n3) queue-rest '<
                             :key 'huffman-node-weight)))))))1

(defun huffman-codes (sequence &key (test 'eql))
  (multiple-value-bind (nodes tree)
      (huffman-tree sequence :test test)
    (labels ((hc (node length bits)
               (let ((left (huffman-node-left node))
                     (right (huffman-node-right node)))
                 (cond
                  ((and (null left) (null right))
                   (setf (huffman-node-encoding node)
                         (make-array length :element-type 'bit
                                     :initial-contents (reverse bits))))
                  (t (hc left (1+ length) (list* 0 bits))
                     (hc right (1+ length) (list* 1 bits)))))))
      (hc tree 0 '())
      nodes)))

(defun print-huffman-code-table (nodes &optional (out *standard-output*))
  (format out "~&Element~10tWeight~20tCode")
  (loop for node being each hash-value of nodes
        do (format out "~&~s~10t~s~20t~s"
                   (huffman-node-element node)
                   (huffman-node-weight node)
                   (huffman-node-encoding node))))
