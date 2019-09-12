function worldcupstages()
    games = ["12", "13", "14", "23", "24", "34"]
    results = "000000"

    function nextresult()
        if (results == "222222")
            return false
        end
        results = lpad(string(parse(Int, results, base=3) + 1, base=3), 6, '0')
        true
    end

    points = zeros(Int, 4, 10)
    while true
        records = zeros(Int, 4)
        for i in 1:length(games)
            if results[i] == '2'
                records[games[i][1] - '0'] += 3
            elseif results[i] == '1'
                records[games[i][1] - '0'] += 1
                records[games[i][2] - '0'] += 1
            elseif results[i] == '0'
                records[games[i][2] - '0'] += 3
            end
        end
        sort!(records)
        for i in 1:4
            points[i, records[i] + 1] += 1
        end
        if !nextresult()
            break
        end
    end

    for (i, place) in enumerate(["First", "Second", "Third", "Fourth"])
        println("$place place: $(points[5 - i, :])")
    end
end

worldcupstages()
