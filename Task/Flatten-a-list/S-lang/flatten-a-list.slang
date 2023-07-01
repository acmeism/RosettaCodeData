define flatten ();

define flatten (list) {
    variable item,
        retval,
        val;
    if (typeof(list) != List_Type) {
        retval = list;
    } else {
        retval = {};
        foreach item (list) {
            foreach val (flatten(item)) {
                list_append(retval, val);
            }
        }
    }
    return retval;
}
