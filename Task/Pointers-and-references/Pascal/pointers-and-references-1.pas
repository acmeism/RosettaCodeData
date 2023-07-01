program pointerDemo;

type
	{
		A new pointer data type is declared by `↑` followed by a data type name,
		the domain.
		
		The domain data type may not have been declared yet, but must be
		declared within the current `type` section.
		
		Most compilers do not support the reference token `↑` as specified in
		the ISO standards 7185 and 10206, but use the alternative `^` (caret).
	}
	integerReference = ^integer;

var
	integerLocation: integerReference;

begin
	{
		The procedure `new` taken one pointer variable and allocates memory for
		one new instance of the pointer domain’s data type (here an `integer`).
		The pointer variable will hold the address of the allocated instance.
	}
	new(integerLocation);
	
	{
		Dereferencing a pointer is done via appending `↑` to the variable’s
		name. All operations on the domain type are now possible.
	}
	integerLocation^ := 42;
	
	{
		The procedure `dispose` takes one pointer variable and releases the
		underlying memory. The supplied variable is otherwise not modified.
	}
	dispose(integerLocation);
	{
		In Pascal, `dispose` is not necessary. Any excess memory is automatically
		released after `program` termination.
	}
end.
