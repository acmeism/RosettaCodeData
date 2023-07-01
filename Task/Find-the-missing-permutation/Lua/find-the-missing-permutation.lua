local permute, tablex = require("pl.permute"), require("pl.tablex")
local permList, pStr = {
    "ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD", "ADCB", "CDAB",
    "DABC", "BCAD", "CADB", "CDBA", "CBAD", "ABDC", "ADBC", "BDCA",
    "DCBA", "BACD", "BADC", "BDAC", "CBDA", "DBCA", "DCAB"
}
for perm in permute.iter({"A","B","C","D"}) do
    pStr = table.concat(perm)
    if not tablex.find(permList, pStr) then print(pStr) end
end
