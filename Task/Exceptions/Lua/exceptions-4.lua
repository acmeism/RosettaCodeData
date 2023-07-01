function throw_error_with_argment(argument)
    return "hello!"
end

status, errmsg = pcall(throw_error_with_argment, "foobar 123")
print("errmsg = ", errmsg)
