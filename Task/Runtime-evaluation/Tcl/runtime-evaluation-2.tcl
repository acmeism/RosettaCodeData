# Create an interpreter with a default set of restrictions
interp create -safe restrictedContext

# Our secret variable
set v "secret"

# Allow some guarded access to the secret from the restricted context.
interp alias restrictedContext doubleSecret {} example
proc example {} {
    global v
    lappend v $v
    return [llength $v]
}

# Evaluate a script in the restricted context
puts [restrictedContext eval {
    append v " has been leaked"
    catch {file delete yourCriticalFile.txt} ;# Will be denied!
    return "there are [doubleSecret] words in the secret: the magic number is [expr {4 + 5}]"
}];       # --> there are 2 words in the secret: the magic number is 9
puts $v;  # --> secret secret
