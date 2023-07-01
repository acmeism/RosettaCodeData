" Class "
MyClass selector: someArgument .
" or equivalently "
foo := MyClass .
foo selector: someArgument.

" Instance "
myInstance selector: someArgument.

" Message with multiple arguments "
myInstance fooWithRed:arg1 green:arg2 blue:arg3 .

" Message with no arguments "
myInstance selector.

" Binary (operator) message"
myInstance + argument .
