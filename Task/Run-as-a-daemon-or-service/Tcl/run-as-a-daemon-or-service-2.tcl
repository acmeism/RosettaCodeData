### Command line argument parsing
if {$argc < 1} {
    puts "usage: $argv0 file ?message...?"
    exit 1
} elseif {$argc == 1} {
    set filename [lindex $argv 0]
    set message "Hi there!"
} else {
    set message [join [lassign $argv filename]]
}

### Daemonize
package require daemon
daemon
close stdout; open $filename    ;# Redirects stdout!

### Print the message to the file every second until killed
proc every {ms body} {eval $body; after $ms [info level 0]}
every 1000 {puts "[clock format [clock seconds]]: $message"}
vwait forever
