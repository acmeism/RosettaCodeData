using Printf

prog = Base.basename(Base.source_path())

println(prog, "'s command-line arguments are:")
for s in ARGS
    println("    ", s)
end
