include file.e

procedure ensure_exists(sequence name)
    object x
    sequence s
    x = dir(name)
    if sequence(x) then
        if find('d',x[1][D_ATTRIBUTES]) then
            s = "directory"
        else
            s = "file"
        end if
        printf(1,"%s %s exists.\n",{name,s})
    else
        printf(1,"%s does not exist.\n",{name})
    end if
end procedure

ensure_exists("input.txt")
ensure_exists("docs")
ensure_exists("/input.txt")
ensure_exists("/docs")
