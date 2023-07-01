(ns a)
(def ^:private priv :secret)

; From REPL, in another namespace 'user':
user=> @a/priv ; fails with: IllegalStateException: var: a/priv is not public
user=> @#'a/priv ; succeeds
:secret
