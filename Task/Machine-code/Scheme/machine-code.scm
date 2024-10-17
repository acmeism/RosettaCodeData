#!/usr/bin/env gosh
#| -*- mode: scheme; coding: utf-8; -*- |#
(use c-wrapper)
(use gauche.uvector)
(use gauche.sequence)
(c-load '("sys/mman.h" "string.h"))

;; target architecture is x86_64 aka amd64
;; add 2 ints and return int
;; lea    (%rsi,%rdi,1),%eax      #x8d #x4 #x3e
;; retq                           #xc3
(define code #u8(#x8d #x4 #x3e #xc3))
(define buf (mmap 0
		  (size-of code)
		  (logior PROT_READ PROT_WRITE PROT_EXEC)
		  (logior MAP_PRIVATE MAP_ANONYMOUS)
		  -1
		  0))

(define (main args)
  (memcpy buf code (size-of code))
  (print ((cast (c-func-ptr <c-uchar> (list <c-uchar> <c-uchar>)) buf) 7 12))
  (munmap buf (size-of code))
  0)
