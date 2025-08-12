// save this section as query_wrapper.c

#include <julia.h>

JULIA_DEFINE_FAST_TLS()

int Query(char *Data, size_t *Length) {
    jl_init();

    jl_eval_string("include(\"query.jl\")"); // Include the Julia file containing Query function

    jl_function_t *func = jl_get_function(jl_main_module, "Query");
    if (!func) {
        jl_atexit_hook(0);
        return 0;
    }

    jl_value_t *buffer = jl_ptr_to_array_1d(jl_uint8_type, Data, *Length, 0);
    jl_value_t *length = jl_box_uint64((uint64_t)Length);

    // Call the query function within Julia
    jl_value_t *result = jl_call2(func, buffer, length);
    if (jl_exception_occurred()) {
        jl_atexit_hook(0);
        return 0;
    }

    // Get return value
    int ret = jl_unbox_int32(result);

    jl_atexit_hook(0);
    return ret; // Return the result of the Query function from the C shared library
}
