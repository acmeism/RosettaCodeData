// Define our own trace method
define trace => {
    local(gb) = givenblock

    // Set a depth counter
    var(::_tracedepth)->isnota(::integer) ? $_tracedepth = 0
    handle => {$_tracedepth--}

    // Only output when supplied a capture
    #gb ? stdoutnl(
        // Indent
        ('\t' * $_tracedepth++) +

        // Type + Method
        #gb->self->type + '.' + #gb->calledname +

        // Call site file
        ': ' + #gb->home->callsite_file +

        // Line number and column number
        ' (line '+#gb->home->callsite_line + ', col ' + #gb->home->callsite_col +')'
    )
    return #gb()
}
