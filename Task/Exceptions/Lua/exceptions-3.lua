function throw_error_with_argment(argument)
    error(string.format("Whoops! argument = %s", argument))
    -- won't ever appear, due to previous error() call
    return "hello!"
end

status, errmsg = pcall(throw_error_with_argment, "foobar 123")
print("errmsg = ", errmsg)
