CL-USER> (cffi:load-foreign-library "libX11.so")
#<CFFI::FOREIGN-LIBRARY {1004F4ECC1}>
CL-USER> (cffi:foreign-funcall "XOpenDisplay"
                               :string #+sbcl (sb-posix:getenv "DISPLAY")
                                       #-sbcl ":0.0"
                               :pointer)
#.(SB-SYS:INT-SAP #X00650FD0)
