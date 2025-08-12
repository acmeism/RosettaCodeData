function throw_error_with_arg(arg)
    return "hello!"
end

local status, result = pcall(throw_error_with_arg, "foobar 123")
if (status ~= 0)
      print("function returned ", result, ", but had errors.")
else
    print("result = ", result)
end
