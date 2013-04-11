#lang racket
(require net/head net/smtp)

(smtp-send-message
 "192.168.0.1"
 "Sender <sender@somewhere.com>"
 '("Recipient <recipient@elsewhere.com>")
 (standard-message-header
  "Sender <sender@somewhere.com>"
  '("Recipient <recipient@elsewhere.com>")
  '() ; CC
  '() ; BCC
  "Subject")
 '("Hello World!"))
