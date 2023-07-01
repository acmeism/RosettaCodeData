/*pragmatic_directives.wren*/

import "os" for Platform

var os
if (Platform.isWindows) {
    import "/windows" for Windows
    os = Windows
} else {
    import "/linux" for Linux
    os = Linux
}
System.print("%(os.message) which has a \"%(os.lineSeparator)\" line separator.")
