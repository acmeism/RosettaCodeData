pg = randbool(SLEN)
pgtail = copy(pg)
while pgtail != mach && pgtail != human
    push!(pg, randbool())
    pgtail = [pgtail[2:end], pg[end]]
end

println(@sprintf("This game lasted %d turns yielding\n    %s",
                 length(pg), pgdecode(pg)))

if human == mach
    println("so you and the computer tied.")
elseif pgtail == mach
    println("so the computer won.")
else
    println("so you won.")
end
