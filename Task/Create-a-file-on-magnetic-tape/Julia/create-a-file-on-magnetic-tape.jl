open("/dev/tape", "w") do f
    write(f, "Hello tape!")
end
