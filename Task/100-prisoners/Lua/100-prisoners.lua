function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function playOptimal()
    local secrets = {}
    for i=1,100 do
        secrets[i] = i
    end
    shuffle(secrets)

    for p=1,100 do
        local success = false

        local choice = p
        for i=1,50 do
            if secrets[choice] == p then
                success = true
                break
            end
            choice = secrets[choice]
        end

        if not success then
            return false
        end
    end

    return true
end

function playRandom()
    local secrets = {}
    for i=1,100 do
        secrets[i] = i
    end
    shuffle(secrets)

    for p=1,100 do
        local choices = {}
        for i=1,100 do
            choices[i] = i
        end
        shuffle(choices)

        local success = false
        for i=1,50 do
            if choices[i] == p then
                success = true
                break
            end
        end

        if not success then
            return false
        end
    end

    return true
end

function exec(n,play)
    local success = 0
    for i=1,n do
        if play() then
            success = success + 1
        end
    end
    return 100.0 * success / n
end

function main()
    local N = 1000000
    print("# of executions: "..N)
    print(string.format("Optimal play success rate: %f", exec(N, playOptimal)))
    print(string.format("Random play success rate: %f", exec(N, playRandom)))
end

main()
