numbers = .array~new()
do i = 1 to 10
    do j = 1 to 10
        numbers[i,j] = random(1, 20)
    end
end

do i = 1 to numbers~dimension(1)
    do j = 1 to numbers~dimension(2)
        say numbers[i,j]
        if numbers[i,j] = 20 then
            leave i
    end
end
