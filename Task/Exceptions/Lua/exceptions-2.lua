function throw_error()
    error("Whoops")
    -- won't ever appear, due to previous error() call
    return "hello!"
end

-- 'status' is false if 'throw_error' threw an error
-- otherwise, when everything went well, it will be true.
-- 'errmsg' contains the error message, plus filename
--  and line number of where the error occurred

local status, errmsg = pcall(throw_error)
print("errmsg = ", errmsg)
