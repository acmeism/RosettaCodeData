function throw_error_with_arg(arg)
    error(string.format("Whoops! argument = %s", arg))
    -- won't ever appear, due to previous error() call
    return "hello!"
end

local status, errmsg = pcall(throw_error_with_arg, "foobar 123")
if (status ~= 0) then
    print("errmsg = ", errmsg)
end
