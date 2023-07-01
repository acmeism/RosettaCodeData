CL-USER> (setf fn (running-stddev))
#<Interpreted Closure (:INTERNAL RUNNING-STDDEV) @ #x21b9a492>
CL-USER> (funcall fn 2)
0.0
CL-USER> (funcall fn 4)
1.0
CL-USER> (funcall fn 4)
0.94280905
CL-USER> (funcall fn 4)
0.8660254
CL-USER> (funcall fn 5)
0.97979593
CL-USER> (funcall fn 5)
1.0
CL-USER> (funcall fn 7)
1.3997085
CL-USER> (funcall fn 9)
2.0
