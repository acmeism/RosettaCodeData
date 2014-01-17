#lang racket

(define *client-outputs* (list (current-output-port)))

(define ((tell-all who current-out) line)
  (for ([out *client-outputs*] #:unless (eq? current-out out))
    (displayln (~a who ": " line) out)))

(define (serve-client input output)
  (define nick (begin
                 (display "Nick: " output)
                 (read-line input)))
  (define tell (tell-all nick output))

  (let loop ([line "(joined)"])
    (cond [(eof-object? line)
           (tell "(left)")
           (set! *client-outputs* (remq output *client-outputs*))
           (close-output-port output)]
          [else
           (tell line)
           (loop (read-line input))])))

(define (chat-server listener)
  (define-values [client-input client-output] (tcp-accept listener))
  (file-stream-buffer-mode client-input 'none)
  (file-stream-buffer-mode client-output 'none)
  (thread (λ ()
            (serve-client client-input client-output)))
  (set! *client-outputs* (cons client-output *client-outputs*))
  (chat-server listener))

(define (start-server)
  (chat-server (tcp-listen 12321)))

(void (thread start-server))
(client (current-input-port) (current-output-port))
