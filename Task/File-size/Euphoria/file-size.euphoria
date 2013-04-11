include file.e

function file_size(sequence file_name)
    object x
    x = dir(file_name)
    if sequence(x) and length(x) = 1 then
        return x[1][D_SIZE]
    else
        return -1 -- the file does not exist
    end if
end function

procedure test(sequence file_name)
    integer size
    size = file_size(file_name)
    if size < 0 then
        printf(1,"%s file does not exist.\n",{file_name})
    else
        printf(1,"%s size is %d.\n",{file_name,size})
    end if
end procedure

test("input.txt") -- in the current working directory
test("/input.txt") -- in the file system root
