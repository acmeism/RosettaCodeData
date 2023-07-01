var result := []
for x ? (x %% 2 <=> 0) in [1,2,3,4,5,6,7,8,9,10] {
    result with= x
}
result
