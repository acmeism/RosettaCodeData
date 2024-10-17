;;Update 2024: the previous code is likely not going to work on modern OS, because there is a need to allocate memory with the correct permissions (readable, writable, and executable). We will update with another machine code, equivalent to the function 'ash' in common lisp

89 f8                	mov    %edi,%eax
89 f1                	mov    %esi,%ecx
d3 e8                	shr    %cl,%eax
c3                   	ret

;;sbcl
(require :sb-posix)

(defconstant +PROT-READ+  1)
(defconstant +PROT-WRITE+ 2)
(defconstant +PROT-EXEC+  4)
(defconstant +MAP-PRIVATE+ 2)
(defconstant +MAP-ANONYMOUS+ #x20)

(defun allocate-executable-memory (size)
  (sb-posix:mmap nil
                 size
                 (logior +PROT-READ+ +PROT-WRITE+ +PROT-EXEC+)
                 (logior +MAP-PRIVATE+ +MAP-ANONYMOUS+)
                 -1
                 0))

;; Example usage:
(defparameter *shellcode* #(#x89 #xf8 #x89 #xf1 #xd3 #xe8 #xc3))
(defparameter *mem-ptr* (allocate-executable-memory (length *shellcode*)))

;; Copy shellcode to allocated memory
(loop for byte across *shellcode*
      for i from 0
      do (setf (sb-sys:sap-ref-8 *mem-ptr* i) byte))

;; Create a callable function pointer
(defparameter *func* (sb-alien:sap-alien *mem-ptr* (sb-alien:function sb-alien:unsigned-int sb-alien:unsigned-int sb-alien:unsigned-int)))

;; Call the function
(sb-alien:alien-funcall *func* 18 1)
;; 9
;;(ash 18 -1) => 9

;; Don't forget to free the memory when done
;;(sb-posix:munmap *mem-ptr* (length *shellcode*))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;old contribution starts here
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

(defparameter callp (loop for byte in mmap
                          for i from 0
		       do
		       (setf (sb-alien:deref pointer i) byte)
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
