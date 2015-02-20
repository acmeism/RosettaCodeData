;;Note that by using the 'CFFI' library, one can apply this procedure portably in any lisp implementation;
;; in this code however I chose to demonstrate only the implementation-dependent programs.

;;CCL
;; Allocate a memory pointer and poke the opcode into it
(defparameter ptr (ccl::malloc 9))

(loop for i in '(139 68 36 4 3 68 36 8 195)
   for j from 0 do
   (setf (ccl::%get-unsigned-byte ptr j) i))

;; Execute with the required arguments and return the result as an unsigned-byte
(ccl::ff-call ptr :UNSIGNED-BYTE 7 :UNSIGNED-BYTE 12 :UNSIGNED-BYTE)

;; Output = 19

;; Free the pointer
(ccl::free ptr)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;SBCL
(defparameter mmap (list 139 68 36 4 3 68 36 8 195))

(defparameter pointer (sb-alien:make-alien sb-alien:unsigned-char (length mmap)))

(defparameter callp (loop FOR i FROM 0 BELOW (length mmap)
		       do
		       (setf (sb-alien:deref pointer i) (elt mmap i))
		       finally
		       (return (sb-alien:cast pointer (function integer integer integer)))))

(sb-alien:alien-funcall callp 7 12)

(loop for i from 0 below 18 collect (sb-alien:deref ptr i))

(sb-alien:free-alien pointer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;CLISP
(defparameter mmap (list 139 68 36 4 3 68 36 8 195))

(defparameter POINTER (FFI:FOREIGN-ADDRESS  (FFI:FOREIGN-ALLOCATE 'FFI:UINT8 :COUNT 9)))

(loop for i in mmap
   for j from 0 do
   (FUNCALL #'(SETF FFI:MEMORY-AS) i POINTER 'FFI:INT j))

(FUNCALL
 (FFI:FOREIGN-FUNCTION POINTER
		       (LOAD-TIME-VALUE
			(FFI:PARSE-C-TYPE
			 '(FFI:C-FUNCTION (:ARGUMENTS 'FFI:INT 'FFI:INT) (:RETURN-TYPE FFI:INT) (:LANGUAGE :STDC)))))
 7 12)

(FFI:FOREIGN-FREE POINTER)
