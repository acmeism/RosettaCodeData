#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <mylib.h>

CAMLprim value
caml_myfunc_a(value unit) {
    myfunc_a();
    return Val_unit;
}

CAMLprim value
caml_myfunc_b(value a, value b) {
    float c = myfunc_b(Int_val(a), Double_val(b));
    return caml_copy_double(c);
}

CAMLprim value
caml_myfunc_c(value ml_array) {
    int i, len;
    int *arr;
    char *s;
    len = Wosize_val(ml_array);
    arr = malloc(len * sizeof(int));
    for (i=0; i < len; i++) {
        arr[i] = Int_val(Field(ml_array, i));
    }
    s = myfunc_c(arr, len);
    free(arr);
    return caml_copy_string(s);
}
