countbulls(a, b) = sum([a[i] == b[i] for i in 1:length(a)])
countcows(a, b) = sum([a[i] == b[j] for i in 1:length(a), j in 1:length(b) if i != j])
validate(a, b) = typeof(a) == Int && typeof(b) == Int && a >= 0 && b >= 0 && a + b < 5

function doguess()
    poss = [a for a in collect(Base.product(1:9,1:9,1:9,1:9)) if length(unique(a))[1]==4]
    while(length(poss) > 0)
        ans = rand(poss, 1)[1]
        while true
            println("My guess: $(ans[1])$(ans[2])$(ans[3])$(ans[4]). How many bulls and cows?")
            regres = match(r"\D*(\d+)\D*(\d+)", readline())
            bul, cow = parse(Int,regres[1]), parse(Int,regres[2])
            if(validate(bul, cow))
                break
            else
                println("Please enter an integer each for bulls and cows.")
            end
        end
        if(bul == 4)
            return ans
        end
        filter!(i -> (countbulls(ans,i), countcows(ans, i)) == (bul, cow), poss)
    end
    Base.throw("ERROR: No solutions found. Inconsistent scoring by other player?")
end

answ = doguess()
println("The winning pick: $(answ[1])$(answ[2])$(answ[3])$(answ[4])")
