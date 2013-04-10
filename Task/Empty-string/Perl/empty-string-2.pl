$s = "";
if ($s) { ... }  # false

# to tell if a string is false because it's empty, or it's plain not there (undefined)
$s = undef;
if (defined $s) { ... } # false; would be true on ""

# though, perl implicitly converts between strings and numbers, so this is also false
$s = "0";
if ($s) { ... } # false; also false on "000", "0.0", "\x0", "0 with text", etc

# but a string that converts to number 0 is not always false, though:
$s = "0 but true";
if ($s) { ... }  # it's true! black magic!
