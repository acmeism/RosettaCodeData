;; using the crypto module from http://www.newlisp.org/code/modules/crypto.lsp.html
;; (import native functions from the crypto library, provided by OpenSSL)
(module "crypto.lsp")
(crypto:md5 "The quick brown fox jumped over the lazy dog's back")
