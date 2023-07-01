# Replace vfs::ftp::Mount to enable vfs::ftp to work in passive
# mode and make that the default.
package require vfs::ftp
proc vfs::ftp::Mount {dirurl local {mode passive}} {
    set dirurl [string trim $dirurl]
    ::vfs::log "ftp-vfs: attempt to mount $dirurl at $local"
    if {[string index $dirurl end] != "/"} {
        ::vfs::log "ftp-vfs: adding missing directory delimiter to mount point"
        append dirurl "/"
    }

    set urlRE {(?:ftp://)?(?:([^@:]*)(?::([^@]*))?@)?([^/:]+)(?::([0-9]*))?/(.*/)?$}
    if {![regexp $urlRE $dirurl - user pass host port path]} {
        return -code error "Sorry I didn't understand\
          the url address \"$dirurl\""
    }

    if {![string length $user]} {
        set user anonymous
    }

    if {![string length $port]} {
        set port 21
    }

    set fd [::ftp::Open $host $user $pass -port $port -output ::vfs::ftp::log -mode $mode]
    if {$fd == -1} {
        error "Mount failed"
    }

    if {$path != ""} {
        if {[catch {
            ::ftp::Cd $fd $path
        } err]} {
            ftp::Close $fd
            error "Opened ftp connection, but then received error: $err"
        }
    }

    if {![catch {vfs::filesystem info $dirurl}]} {
        # unmount old mount
        ::vfs::log "ftp-vfs: unmounted old mount point at $dirurl"
        vfs::unmount $dirurl
    }
    ::vfs::log "ftp $host, $path mounted at $fd"
    vfs::filesystem mount $local [list vfs::ftp::handler $fd $path]
    # Register command to unmount
    vfs::RegisterMount $local [list ::vfs::ftp::Unmount $fd]
    return $fd
}
