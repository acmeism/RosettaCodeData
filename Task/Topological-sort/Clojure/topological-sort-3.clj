Clojure 1.1.0
1:1 user=> #<Namespace topo>
1:2 topo=> (topo-sort good-sample)
(:std :synopsys :ieee :gtech :ramlib :dware :std_cell_lib :dw07 :dw06 :dw05 :dw01 :dw02 :des_system_lib :dw03 :dw04)
1:3 topo=> (topo-sort bad-sample)
"ERROR: cycles remain among (:dw01 :dw04 :dw03 :des_system_lib)"
