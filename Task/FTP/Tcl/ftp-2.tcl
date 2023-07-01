package require vfs::urltype
vfs::urltype::Mount ftp

# Patch to enable FTP passive mode.
source vfsftpfix.tcl

set dir [pwd]
cd ftp://kernel.org/pub/linux/kernel
foreach line [glob -dir ftp://kernel.org/pub/linux/kernel *] {
    puts $line
}
file copy README [file join $dir README]
