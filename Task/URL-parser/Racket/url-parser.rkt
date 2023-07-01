#lang racket/base
(require racket/match net/url)
(define (debug-url-string U)
  (match-define (url s u h p pa? (list (path/param pas prms) ...) q f) (string->url U))
  (printf "URL: ~s~%" U)
  (printf "-----~a~%" (make-string (string-length (format "~s" U)) #\-))
  (when #t          (printf "scheme:         ~s~%" s))
  (when u           (printf "user:           ~s~%" u))
  (when h           (printf "host:           ~s~%" h))
  (when p           (printf "port:           ~s~%" p))
  ;; From documentation link in text:
  ;; > For Unix paths, the root directory is not included in `path';
  ;; > its presence or absence is implicit in the path-absolute? flag.
  (printf "path-absolute?: ~s~%" pa?)
  (printf "path  bits:     ~s~%" pas)
  ;; prms will often be a list of lists. this will print iff
  ;; one of the inner lists is not null
  (when (memf pair? prms)
    (printf "param bits:     ~s [interleaved with path bits]~%" prms))
  (unless (null? q) (printf "query:          ~s~%" q))
  (when f           (printf "fragment:       ~s~%" f))
  (newline))

(for-each
 debug-url-string
 '("foo://example.com:8042/over/there?name=ferret#nose"
   "urn:example:animal:ferret:nose"
   "jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true"
   "ftp://ftp.is.co.za/rfc/rfc1808.txt"
   "http://www.ietf.org/rfc/rfc2396.txt#header1"
   "ldap://[2001:db8::7]/c=GB?objectClass=one&objectClass=two"
   "mailto:John.Doe@example.com"
   "news:comp.infosystems.www.servers.unix"
   "tel:+1-816-555-1212"
   "telnet://192.0.2.16:80/"
   "urn:oasis:names:specification:docbook:dtd:xml:4.1.2"))
