define try(exception) => {
    local(
        gb = givenblock,
        error
    )
    handle => {
        // Only relay error if it's not the specified exception
        if(#error) => {
            if(#error->get(2) == #exception) => {
                stdoutnl('Handled exception: '+#error->get(2))
            else
                stdoutnl('Throwing exception: '+#error->get(2))
                fail(:#error)
            }
        }
    }
    protect => {
        handle_error => {
            #error = (:error_code,error_msg,error_stack)
        }
        #gb()
    }
}

define foo => {
    stdoutnl('foo')
    try('U0') => { bar }
    try('U0') => { bar }
}

define bar => {
    stdoutnl('- bar')
    baz()
}

define baz => {
    stdoutnl('  - baz')
    var(bazzed) ? fail('U1') | $bazzed = true
    fail('U0')
}
