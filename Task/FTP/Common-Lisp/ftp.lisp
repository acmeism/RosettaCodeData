(use-package :ftp)

(with-ftp-connection (conn :hostname "ftp.hq.nasa.gov"
                           :passive-ftp-p t)
  (send-cwd-command conn "/pub/issoutreach/Living in Space Stories (MP3 Files)")
  (send-list-command conn t)
  (let ((filename "Gravity in the Brain.mp3"))
    (retrieve-file conn filename filename :type :binary)))
