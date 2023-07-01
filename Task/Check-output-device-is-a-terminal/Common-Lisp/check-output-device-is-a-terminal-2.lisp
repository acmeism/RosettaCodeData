(ffi:clines "
    #include <sys/ioctl.h>
    #include <unistd.h>
    int ttyPredicate() {
      return isatty(fileno(stdout));
     }")

(ffi:def-function
    ("ttyPredicate" c-ttyp)
    () :returning :int)

(defun tty-p()
  (if (= 1 (c-ttyp))
      t
      nil))

(format T "stdout is~:[ not~;~] a terminal~%" (tty-p))
(quit)
