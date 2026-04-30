import math

fn main() {
    xs := [-5, 5]
    ps := [2, 3]
    for x in xs {
        for p in ps {
            print('x =${x:2d} p=${p:2d}   ')
            // compute powers
            x_pow_p := int(math.pow(f64(x), f64(p)))
            neg_x_pow_p := -x_pow_p
            neg_x := -x
            neg_x_pow_p_paren := int(math.pow(f64(neg_x), f64(p)))
            // hash map of `string: value`
			sr := {
				'-x**p': neg_x_pow_p
				'-(x)**p': neg_x_pow_p
				'(-x)**p': neg_x_pow_p_paren
				'-(x**p)': neg_x_pow_p
			}	
            for key, val in sr {
                print('${key} ${val:4d}   ')
            }
            println('')
        }
    }
}
