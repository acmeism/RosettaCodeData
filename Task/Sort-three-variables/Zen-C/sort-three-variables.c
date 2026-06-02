import "std/sort.zc"

fn string_comparer(a: const void*, b: const void*) -> int {
    return strcmp(*(char**)a, *(char**)b);
}

fn main() {
    let x = "lions, tigers, and";
    let y = "bears, oh my!";
    let z = "(from the \"Wizard of OZ\")";
    let arr = [x, y, z];
    qsort(arr, 3, sizeof(const char*), string_comparer);
    x = arr[0];
    y = arr[1];
    z = arr[2];
    println "After sorting strings:";
    println "  x = {x}";
    println "  y = {y}";
    println "  z = {z}";

    let i = 77444;
    let j = -12;
    let k = 0;
    let arr2 = [i, j, k];
    sort_int((int*)arr2, 3);
    i = arr2[0];
    j = arr2[1];
    k = arr2[2];
    println "\nAfter sorting integers:";
    println "  i = {i}";
    println "  j = {j}";
    println "  k = {k}";

    let f: f32 = 11.3;
    let g: f32 = -9.7;
    let h: f32 = 11.17;
    let arr3 = [f, g, h];
    sort_float((f32*)arr3, 3);
    f = arr3[0];
    g = arr3[1];
    h = arr3[2];
    println "\nAfter sorting floats:";
    println "  f = {f:g}";
    println "  g = {g:g}";
    println "  h = {h:g}";
}
