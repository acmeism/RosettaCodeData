#lang racket/base

(require racket/system
         (only-in racket/port with-output-to-string)
         tests/eli-tester)

(test
 ;; system runs command and outputs to current output port (which is stdout unless we catch it)
 (system "ls /etc/motd") => #t
 ;; it throws an error on non-zero exit code (so I need to catch it in this error handler)
 (system "false") => #f       ; nothing printed to stdout/stderr
 (system "ls /etc/mosh") => #f ; error report printed to stderr
 ;; output can be captured by redirecting stdout/stderr (which are known as current-output-port and
 ;; current-error-port in racket parlance).
 ;; the command printed a \n, so there is a newline captured by the system command
 (with-output-to-string (λ () (system "ls /etc/motd"))) => "/etc/motd\n"
 ;; no \n is captured when none is captured
 (with-output-to-string (λ () (system "echo -n foo"))) => "foo"
 ;; error is still not captured (it's still printed to stderr)
 (with-output-to-string (λ () (system "echo -n foo; echo bar 1>&2"))) => "foo"
 ;; we can capture both with:
 (let* ((out-str-port (open-output-string))
        (err-str-port (open-output-string))
        (system-rv
         (parameterize ((current-output-port out-str-port) (current-error-port err-str-port))
           (system "echo -n foo; echo bar 1>&2"))))
   (values system-rv (get-output-string out-str-port) (get-output-string err-str-port)))
 => (values #t "foo" "bar\n"))
