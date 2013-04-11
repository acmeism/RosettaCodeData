*Main> toposort depLibs
["std","synopsys","ieee","std_cell_lib","dware","dw02","gtech","dw01","ramlib","des_system_lib","dw03","dw04","dw05","dw06","dw07"]

*Main> toposort $ (\(xs,(k,ks):ys) -> xs++ (k,ks++" dw04"):ys) $ splitAt 1  depLibs
*** Exception: Dependency cycle detected for libs [["dw01","dw04"]]
