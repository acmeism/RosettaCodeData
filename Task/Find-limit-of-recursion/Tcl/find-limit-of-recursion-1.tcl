proc recur i {
    puts "This is depth [incr i]"
    catch {recur $i}; # Trap error from going too deep
}
recur 0
