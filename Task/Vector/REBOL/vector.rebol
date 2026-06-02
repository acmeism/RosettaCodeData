Rebol [
    title: "Rosetta code: Vector"
    file:  %Vector.r3
    url:   https://rosettacode.org/wiki/Vector
    needs: 3.20.0
]

;; Default vector's value type is float64!
v1: make vector! [5.0 7.0]  ;== #(float64! [5.0 7.0])
v2: make vector! [2.0 3.0]  ;== #(float64! [2.0 3.0])
v1 + v2                     ;== #(float64! [7.0 10.0])
v1 - v2                     ;== #(float64! [3.0 4.0])
(copy v1) * 11              ;== #(float64! [55.0 77.0])
(copy v1) / 2               ;== #(float64! [2.5 3.5])

;; Vector accessors:
v1/signed                   ;== #(true)
v1/type                     ;== 'decimal!
v1/size                     ;== 64
v1/length                   ;== 2
v1/minimum                  ;== 5.0
v1/maximum                  ;== 7.0
v1/range                    ;== 2.0
v1/sum                      ;== 12.0
v1/mean                     ;== 6.0
v1/median                   ;== 6.0
v1/variance                 ;== 2.0 ;(sample variance)
v1/population-deviation     ;== 1.0
v1/sample-deviation         ;== 1.4142135623731
;; Getting all info at once:
query v1 object!            ;== make object! [signed: #(true) ...]
;; Getting just custom info:
query v1 [sum mean]         ;== [sum: 12.0 mean: 6.0]
;; Or just values
query v1 [:sum :mean]       ;== [12.0 6.0]

;; All supported vector types:
;;     uint8! uint16! uint32! uint64!
;;     int8!  int16!  int32!  int64!
;;     float32! float64!
;; Or short aliases:
;;     u8! u16! u32! u64! i8! i16! i32! i64! f32! f64!

data: [1 2.5 300] type: 'uint16!
v3: make vector! reduce [type data] ;== #(uint16! [1 2 300]) ;; 2.5 value was truncated!
;; Conversion to binary:
to binary! v3                       ;== #{010002002C01}

;; It should be noted, that values over vector's type limit are truncated!
make vector! [u8! [100 300]]        ;==  #(uint8! [100 44])

;; To create an empty vector:
make vector! [f32! 3]               ;== #(float32! [0.0 0.0 0.0])
