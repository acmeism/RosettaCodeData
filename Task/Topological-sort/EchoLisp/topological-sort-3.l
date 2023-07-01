(define g (make-graph "VHDL"))
(add-dependencies g dependencies)
(graph-print g)

(t-sort g)
→ t-sort     (std synopsys ieee dware dw02 dw05 dw06 dw07 gtech dw01 dw03 dw04 ramlib
             std_cell_lib des_system_lib)

;; Error case
;; add dw01 -> dw04
(t-sort g)
t-sort     (std synopsys ieee dware dw02 dw05 dw06 dw07 gtech ramlib std_cell_lib)
⛔️ error: ♻️ t-sort:cyclic (dw04 dw01)	
