package require sound

fconfigure stdout -buffering none
puts -nonewline "How long to wait for (seconds): "
gets stdin delay
puts -nonewline "What file to play: "
gets stdin soundFile

snack::sound snd
snd read $soundFile
after [expr {$delay * 1000}] {snd play -command {set done 1}}
vwait done

catch {snd stop}
snd destroy
puts "all done"
exit
