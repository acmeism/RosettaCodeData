#lang racket
(require 2htdp/image)

(overlay
 (star-polygon 100 5 2 "outline" (make-pen "blue" 4 "solid" "round" "round"))
 (star-polygon 100 5 2 "solid" "cyan"))
