function randPW (length)
    local index, pw, rnd = 0, ""
    local chars = {
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "abcdefghijklmnopqrstuvwxyz",
        "0123456789",
        "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"
    }
    repeat
        index = index + 1
        rnd = math.random(chars[index]:len())
        if math.random(2) == 1 then
            pw = pw .. chars[index]:sub(rnd, rnd)
        else
            pw = chars[index]:sub(rnd, rnd) .. pw
        end
        index = index % #chars
    until pw:len() >= length
    return pw
end

math.randomseed(os.time())
if #arg ~= 2 then
    print("\npwgen.lua")
    print("=========\n")
    print("A Lua script to generate random passwords.\n")
    print("Usage:    lua pwgen.lua [password length] [number of passwords to generate]\n")
    os.exit()
end
for i = 1, arg[2] do print(randPW(tonumber(arg[1]))) end
