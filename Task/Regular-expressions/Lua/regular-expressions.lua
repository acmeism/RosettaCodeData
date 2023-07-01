test = "My name is Lua."
pattern = ".*name is (%a*).*"

if test:match(pattern) then
    print("Name found.")
end

sub, num_matches = test:gsub(pattern, "Hello, %1!")
print(sub)
