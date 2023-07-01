package require critcl
package provide stepaway 1.0
critcl::ccode {
    #include <math.h>
    #include <float.h>
}
critcl::cproc stepup {double value} double {
    return nextafter(value, DBL_MAX);
}
critcl::cproc stepdown {double value} double {
    return nextafter(value, -DBL_MAX);
}
