(import (otus ffi))
(define libcrypto (load-dynamic-library "libcrypto.so.1.0.0"))
(define MD5 (libcrypto type-vptr "MD5" type-string fft-unsigned-long type-string))
