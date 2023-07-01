> (defparameter *dependency-graph*
  '((des-system-lib   std synopsys std-cell-lib des-system-lib dw02 dw01 ramlib ieee)
    (dw01             ieee dw01 dw04 dware gtech)
    (dw02             ieee dw02 dware)
    (dw03             std synopsys dware dw03 dw02 dw01 ieee gtech)
    (dw04             dw04 ieee dw01 dware gtech)
    (dw05             dw05 ieee dware)
    (dw06             dw06 ieee dware)
    (dw07             ieee dware)
    (dware            ieee dware)
    (gtech            ieee gtech)
    (ramlib           std ieee)
    (std-cell-lib     ieee std-cell-lib)
    (synopsys)))
*DEPENDENCY-GRAPH*

> (topological-sort *dependency-graph*)
(IEEE DWARE DW02 DW05 DW06 DW07 GTECH STD-CELL-LIB SYNOPSYS STD RAMLIB)
NIL
#<EQL Hash Table{4} 200C9023>

> (describe (third /))

#<EQL Hash Table{4} 200C9023> is a HASH-TABLE
DW01                (1 DW04 DW03 DES-SYSTEM-LIB)
DW04                (1 DW01)
DW03                (1)
DES-SYSTEM-LIB      (1)
