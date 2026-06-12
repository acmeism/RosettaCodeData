def count(stream): reduce stream as $i (0; .+1);

count([0,1,2] | permutations_with_replacements(4))
# output: 81
