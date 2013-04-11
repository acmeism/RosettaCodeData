#include <order/interpreter.h>

// Get FB for one number
#define ORDER_PP_DEF_8fizzbuzz ORDER_PP_FN(            \
8fn(8N,                                                \
    8let((8F, 8fn(8N, 8G,                              \
                  8is_0(8remainder(8N, 8G)))),         \
         8cond((8ap(8F, 8N, 15), 8quote(fizzbuzz))     \
               (8ap(8F, 8N, 3), 8quote(fizz))          \
               (8ap(8F, 8N, 5), 8quote(buzz))          \
               (8else, 8N)))) )

// Print E followed by a comma (composable, 8print is not a function)
#define ORDER_PP_DEF_8print_el ORDER_PP_FN( \
8fn(8E, 8print(8E 8comma)) )

ORDER_PP(  // foreach instead of map, to print but return nothing
  8seq_for_each(8compose(8print_el, 8fizzbuzz), 8seq_iota(1, 100))
)
