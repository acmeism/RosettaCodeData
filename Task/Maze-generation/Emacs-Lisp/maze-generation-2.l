#!/usr/bin/env emacs -script
;; -*- lexical-binding: t -*-
;;> Simple maze generator.
;;> Example: ./maze-generate 20 20

(add-to-list 'load-path (file-name-directory load-file-name))
(require 'cl-lib)
(require 'maze)

(generate (string-to-number (elt command-line-args-left 0))
          (string-to-number (elt command-line-args-left 1)))
