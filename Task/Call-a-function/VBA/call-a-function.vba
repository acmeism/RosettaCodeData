'definitions/declarations

'Calling a function that requires no arguments
Function no_arguments() As String
    no_arguments = "ok"
End Function

'Calling a function with a fixed number of arguments
Function fixed_number(argument1 As Integer, argument2 As Integer)
    fixed_number = argument1 + argument2
End Function

'Calling a function with optional arguments
Function optional_parameter(Optional argument1 = 1) As Integer
    'Optional parameters come at the end of the parameter list
    optional_parameter = argument1
End Function

'Calling a function with a variable number of arguments
Function variable_number(arguments As Variant) As Integer
    variable_number = UBound(arguments)
End Function

'Calling a function with named arguments
Function named_arguments(argument1 As Integer, argument2 As Integer) As Integer
    named_arguments = argument1 + argument2
End Function

'Using a function in statement context
Function statement() As String
    Debug.Print "function called as statement"
    statement = "ok"
End Function

'Using a function in first-class context within an expression
'see call the functions

'Obtaining the return value of a function
Function return_value() As String
    return_value = "ok"
End Function

'Distinguishing built-in functions and user-defined functions
'There is no way to distinguish built-in function and user-defined functions

'Distinguishing subroutines And functions
'subroutines are declared with the reserved word "sub" and have no return value
Sub foo()
    Debug.Print "subroutine",
End Sub
'functions are declared with the reserved word "function" and can have a return value
Function bar() As String
    bar = "function"
End Function

'Stating whether arguments are passed by value or by reference
Function passed_by_value(ByVal s As String) As String
    s = "written over"
    passed_by_value = "passed by value"
End Function
'By default, parameters in VBA are by reference
Function passed_by_reference(ByRef s As String) As String
    s = "written over"
    passed_by_reference = "passed by reference"
End Function

'Is partial application possible and how
'I don't know

'calling a subroutine with arguments does not require parentheses
Sub no_parentheses(myargument As String)
    Debug.Print myargument,
End Sub

'call the functions
Public Sub calling_a_function()
    'Calling a function that requires no arguments
    Debug.Print "no arguments", , no_arguments
    Debug.Print "no arguments", , no_arguments()
    'Parentheses are not required

    'Calling a function with a fixed number of arguments
    Debug.Print "fixed_number", , fixed_number(1, 1)

    'Calling a function with optional arguments
    Debug.Print "optional parameter", optional_parameter
    Debug.Print "optional parameter", optional_parameter(2)

    'Calling a function with a variable number of arguments
    Debug.Print "variable number", variable_number([{"hello", "there"}])
    'The variable number of arguments have to be passed as an array

    'Calling a function with named arguments
    Debug.Print "named arguments", named_arguments(argument2:=1, argument1:=1)

    'Using a function in statement context
    statement

    'Using a function in first-class context within an expression
    s = "no_arguments"
    Debug.Print "first-class context", Application.Run(s)
    'A function name can be passed as argument in a string

    'Obtaining the return value of a function
    returnvalue = return_value
    Debug.Print "obtained return value", returnvalue

    'Distinguishing built-in functions and user-defined functions

    'Distinguishing subroutines And functions
    foo
    Debug.Print , bar

    'Stating whether arguments are passed by value or by reference
    Dim t As String
    t = "unaltered"
    Debug.Print passed_by_value(t), t
    Debug.Print passed_by_reference(t), t

    'Is partial application possible and how
    'I don 't know

    'calling a subroutine with arguments does not require parentheses
    no_parentheses "calling a subroutine"
    Debug.Print "does not require parentheses"
    Call no_parentheses("deprecated use")
    Debug.Print "of parentheses"

End Sub
