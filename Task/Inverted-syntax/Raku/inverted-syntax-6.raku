repeat {
    $_ = prompt "Gimme a number: ";
} until /^\d+$/;

repeat until /^\d+$/ {
    $_ = prompt "Gimme a number: ";
}
