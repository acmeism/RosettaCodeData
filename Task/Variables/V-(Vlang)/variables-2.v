// will not work unless `-enable-globals` compiler flag used
// (...), for multiple global variables
__global (
	array_b = [3][3]int{}
	var_best_i = 0
	var_best_j = 0
)
// preferable to use structs
struct Better {
	mut:
	array_b [3][3]int
	var_best_i int
	var_best_j int
}
