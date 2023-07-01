$ awk '{ for (i = 1; i <= NF; i++) print $i, $1 }' <<! | tsort
> des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee
> dw01             ieee dw01 dware gtech
> dw02             ieee dw02 dware
> dw03             std synopsys dware dw03 dw02 dw01 ieee gtech
> dw04             dw04 ieee dw01 dware gtech
> dw05             dw05 ieee dware
> dw06             dw06 ieee dware
> dw07             ieee dware
> dware            ieee dware
> gtech            ieee gtech
> ramlib           std ieee
> std_cell_lib     ieee std_cell_lib
> synopsys
> !
ieee
dware
dw02
dw05
dw06
dw07
gtech
dw01
dw04
std_cell_lib
synopsys
std
dw03
ramlib
des_system_lib
