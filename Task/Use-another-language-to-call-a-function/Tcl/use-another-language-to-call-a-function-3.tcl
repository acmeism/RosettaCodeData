int Query (char * Data, size_t * Length) {
    const char *str;
    int len;

    if (Tcl_Eval(interp, "Query") != TCL_OK) {
        return 0;
    }
    str = Tcl_GetStringFromObj(Tcl_GetObjResult(interp), &len);
    if (len+1 > Length) {
        return 0;
    }
    memcpy(Data, str, len+1);
    return 1;
}
