require "lfs"
for i, path in ipairs({"input.txt", "/input.txt", "docs", "/docs"}) do
    local mode = lfs.attributes(path, "mode")
    if mode then
        print(path .. " exists and is a " .. mode .. ".")
    else
        print(path .. " does not exist.")
    end
end
