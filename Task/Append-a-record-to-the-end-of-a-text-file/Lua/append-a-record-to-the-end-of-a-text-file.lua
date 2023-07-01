function append(tbl,filename)
    local file,err = io.open(filename, "a")
    if err then return err end

    file:write(tbl.account..":")
    file:write(tbl.password..":")
    file:write(tbl.uid..":")
    file:write(tbl.gid..":")

    for i,v in ipairs(tbl.gecos) do
        if i>1 then
            file:write(",")
        end
        file:write(v)
    end
    file:write(":")

    file:write(tbl.directory..":")
    file:write(tbl.shell.."\n")

    file:close()
end

local smith = {}
smith.account = "jsmith"
smith.password = "x"
smith.uid = 1001
smith.gid = 1000
smith.gecos = {"Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org"}
smith.directory = "/home/jsmith"
smith.shell = "/bin/bash"
append(smith, ".passwd")

local doe = {}
doe.account = "jdoe"
doe.password = "x"
doe.uid = 1002
doe.gid = 1000
doe.gecos = {"Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org"}
doe.directory = "/home/jdoe"
doe.shell = "/bin/bash"
append(doe, ".passwd")

local xyz = {}
xyz.account = "xyz"
xyz.password = "x"
xyz.uid = 1003
xyz.gid = 1000
xyz.gecos = {"X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org"}
xyz.directory = "/home/xyz"
xyz.shell = "/bin/bash"
append(xyz, ".passwd")
