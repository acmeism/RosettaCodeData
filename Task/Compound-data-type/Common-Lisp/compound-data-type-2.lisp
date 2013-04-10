CL-USER> (setf a (make-point))          ;The default constructor using the default values for x and y
#S(POINT :X 0 :Y 0)
CL-USER> (setf b (make-point :x 5.5 :y #C(0 1)))  ;Dynamic datatypes are the default
#S(POINT :X 5.5 :Y #C(0 1))                       ;y has been set to the imaginary number i (using the Common Lisp complex number data type)
CL-USER> (point-x b)                    ;The default name for the accessor functions is structname-slotname
5.5
CL-USER> (point-y b)
#C(0 1)
CL-USER> (setf (point-y b) 3)           ;The accessor is setfable
3
CL-USER> (point-y b)
3
