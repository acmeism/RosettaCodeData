-- Lua pattern docs at http://www.lua.org/manual/5.1/manual.html#5.4.1
function fileExt (filename) return filename:match("(%.%w+)$") or "" end

local testCases = {
    "http://example.com/download.tar.gz",
    "CharacterModel.3DS",
    ".desktop",
    "document",
    "document.txt_backup",
    "/etc/pam.d/login"
}
for _, example in pairs(testCases) do
    print(example .. ' -> "' .. fileExt(example) .. '"')
end
