(quicklisp:quickload :Drakma)            ; or load it in another way

(defun mac-vendor (mac)
  (check-type mac string "A MAC address as a string")
  (multiple-value-bind (vendor status)
    (drakma:http-request (format nil "http://api.macvendors.com/~a" mac))
    (if (= 200 status)
      (format t "~%Vendor is ~a" vendor)
      (error "~%Not a MAC address: ~a" mac))))
