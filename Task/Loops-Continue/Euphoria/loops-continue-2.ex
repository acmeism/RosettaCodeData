include std\console.e --only for any_key to make running command window easier on windows

for i = 1 to 10 do
    if remainder(i,5) = 0 then
        switch i do
            case 10 then
                printf(1,"%d ",i)
                break --new to euphoria 4.0.0+
            case else
                printf(1,"%d\n", i)
        end switch

        else
            printf(1,"%d, ", i)
            continue --new to euphoria 4.0.0+
    end if
end for
any_key()
