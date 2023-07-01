local dTab = {day = 25, month = 12}
for year = 2008, 2121 do
    dTab.year = year
    if os.date("%A", os.time(dTab)) == "Sunday" then
        print(year)
    end
end
