int Query (char * Data, size_t * Length) {
    Tcl_Obj *arguments[2];
    int code;

    arguments[0] = Tcl_NewStringObj("Query", -1); /* -1 for "use up to zero byte" */
    arguments[1] = Tcl_NewStringObj(Data, Length);
    Tcl_IncrRefCount(arguments[0]);
    Tcl_IncrRefCount(arguments[1]);
    if (Tcl_EvalObjv(interp, 2, arguments, 0) != TCL_OK) {
        /* Was an error or other exception; report here... */
        Tcl_DecrRefCount(arguments[0]);
        Tcl_DecrRefCount(arguments[1]);
        return 0;
    }
    Tcl_DecrRefCount(arguments[0]);
    Tcl_DecrRefCount(arguments[1]);
    if (Tcl_GetObjResult(NULL, Tcl_GetObjResult(interp), &code) != TCL_OK) {
        /* Not an integer result */
        return 0;
    }
    return code;
}
