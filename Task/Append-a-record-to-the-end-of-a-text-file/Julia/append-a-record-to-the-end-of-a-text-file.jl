using SHA  # security instincts say do not write bare passwords to a shared file even in toy code :)

mutable struct Personnel
    fullname::String
    office::String
    extension::String
    homephone::String
    email::String
    Personnel(ful,off,ext,hom,ema) = new(ful,off,ext,hom,ema)
end

mutable struct Passwd
     account::String
     password::String
     uid::Int32
     gid::Int32
     personal::Personnel
     directory::String
     shell::String
     Passwd(acc,pas,uid,gid,per,dir,she) =  new(acc,pas,uid,gid,per,dir,she)
end

function writepasswd(filename, passrecords)
    if(passrecords isa Array) == false
        passrecords = [passrecords]
    end
    fh = open(filename, "a") # should throw an exception if cannot open in a locked or exclusive mode for append
    for pas in passrecords
        record = join([pas.account, bytes2hex(sha256(pas.password)), pas.uid, pas.gid,
                 join([pas.personal.fullname, pas.personal.office, pas.personal.extension,
                 pas.personal.homephone, pas.personal.email], ','),
                 pas.directory, pas.shell], ':')
        write(fh, record, "\n")
    end
    close(fh)
end

const jsmith = Passwd("jsmith","x",1001, 1000, Personnel("Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org"), "/home/jsmith", "/bin/bash")
const jdoe = Passwd("jdoe","x",1002, 1000, Personnel("Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org"), "/home/jdoe", "/bin/bash")
const xyz = Passwd("xyz","x",1003, 1000, Personnel("X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org"), "/home/xyz", "/bin/bash")

const pfile = "pfile.csv"
writepasswd(pfile, [jsmith, jdoe])
println("Before last record added, file is:\n$(readstring(pfile))")
writepasswd(pfile, xyz)
println("After last record added, file is:\n$(readstring(pfile))")
