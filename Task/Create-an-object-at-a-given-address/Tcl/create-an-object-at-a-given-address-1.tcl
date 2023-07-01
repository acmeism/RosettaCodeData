package require critcl

# A command to 'make an integer object' and couple it to a Tcl variable
critcl::cproc linkvar {Tcl_Interp* interp char* var1} int {
    int *intPtr = (int *) ckalloc(sizeof(int));

    *intPtr = 0;
    Tcl_LinkVar(interp, var1, (void *) intPtr, TCL_LINK_INT);
    return (int) intPtr;
}

# A command to couple another Tcl variable to an 'integer object'; UNSAFE!
critcl::cproc linkagain(Tcl_Interp* interp int addr char* var2} void {
    int *intPtr = (int *) addr;

    Tcl_LinkVar(interp, var2, (void *) intPtr, TCL_LINK_INT);
}

# Conventionally, programs that use critcl structure in packages
# This is used to prevent recompilation, especially on systems like Windows
package provide machAddrDemo 1
