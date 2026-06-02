;; make image using pair
img: make image! 2x2
;; make image using pair and RGB tuple
img: make image! [2x2 255.0.0]
;; make image using pair and RGBA tuple"
img: make image! [2x2 255.0.0.10]

;; Rebol3's construction syntax
img1: #(image! 4x4)       ;; white by default
img2: #(image! 2x2 0.0.0) ;; black image

;; Raw binary access:
probe img1/rgb
;== #{
;== FFFFFFFFFFFFFFFFFFFFFFFF
;== FFFFFFFFFFFFFFFFFFFFFFFF
;== FFFFFFFFFFFFFFFFFFFFFFFF
;== FFFFFFFFFFFFFFFFFFFFFFFF}

;; Blit image to image
change at img1 2x2 img2
probe img1/rgb
;== #{
;== FFFFFFFFFFFFFFFFFFFFFFFF
;== FFFFFF000000000000FFFFFF
;== FFFFFF000000000000FFFFFF
;== FFFFFFFFFFFFFFFFFFFFFFFF}

;; Pixel access
img1/1   ;== 255.255.255.255
img2/1   ;== 0.0.0.255
img1/2x2 ;== 0.0.0.255

;; Other binary accessors:
img: #(image! 2x1)
img/1: 1.2.3.100
img/2: 4.5.6.200
img/rgba    ;== #{01020364040506C8}
img/rgbo    ;== #{0102039B04050637}
img/argb    ;== #{64010203C8040506}
img/orgb    ;== #{9B01020337040506}
img/bgra    ;== #{03020164060504C8}
img/bgro    ;== #{0302019B06050437}
img/abgr    ;== #{64030201C8060504}
img/obgr    ;== #{9B03020137060504}
img/opacity ;== #{9B37}
img/alpha   ;== #{64C8}

;; Drawing may be done using extensions like Blend2D
import blend2d ;@@ https://github.com/Siskin-framework/Rebol-Blend2D
img: draw 100x100 [
   fill red
   pen black
   line-width 10
   circle 50x50 20
   fill none
   line 0x0 100x100
]
