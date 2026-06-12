package provide daemon 1
package require critcl

critcl::ccode {
    #include <stdlib.h>
}
critcl::cproc daemon {Tcl_Interp* interp} ok {
    if (daemon(0, 0) < 0) {
	Tcl_AppendResult(interp, "cannot switch to daemon operation: ",
		Tcl_PosixError(interp), NULL);
	return TCL_ERROR;
    }
    return TCL_OK;
}
