;; using the crypto module from http://www.newlisp.org/code/modules/crypto.lsp.html
;; (import native functions from the crypto library, provided by OpenSSL)
(module "crypto.lsp")
(crypto:sha1 "Rosetta Code")
