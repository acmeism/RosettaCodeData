function truncate_file(fname, size):
    open(fname, "r+") do f
        truncate(f, size)
    end
end
