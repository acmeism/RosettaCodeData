(defun my-send-email (from to cc subject text)
  (with-temp-buffer
    (insert "From: " from "\n"
            "To: " to "\n"
            "Cc: " cc "\n"
            "Subject: " subject "\n"
            mail-header-separator "\n"
            text)
    (funcall send-mail-function)))

(my-send-email "from@example.com" "to@example.com" ""
               "very important"
               "body\ntext\n")
