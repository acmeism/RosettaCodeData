puts "nodes(5) = [nodes 5]"
puts "weights(5) = [weights [nodes 5]]"
set exp {x {expr {exp($x)}}}
puts "int(exp,-3,3) = [gausslegendreintegrate $exp 5 -3 3]"
