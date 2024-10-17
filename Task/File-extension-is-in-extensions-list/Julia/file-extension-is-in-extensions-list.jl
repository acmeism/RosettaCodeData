isext(filename, extensions) = any(x -> endswith(lowercase(filename), lowercase(x)), "." .* extensions)

# Test
extensions = ["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"]
for f in ["MyData.a##", "MyData.tar.Gz", "MyData.gzip", "MyData.7z.backup", "MyData...", "MyData", "MyData_v1.0.tar.bz2", "MyData_v1.0.bz2"]
    @printf("%20s : %5s\n", f, isext(f, extensions))
end
