given lc prompt("Done? ") {
    when 'yes' { return }
    when 'no'  { next }
    default    { say "Please answer either yes or not." }
}
