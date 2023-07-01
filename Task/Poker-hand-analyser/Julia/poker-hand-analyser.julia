sorteddeck = [string(r) * s for s in "♣♦♥♠", r in "23456789TJQKA"]

cardlessthan(card1, card2) = indexin(x, sorteddeck)[1] < indexin(y, sorteddeck)[1]

decksort(d) = sort(d, lt=cardlessthan)

highestrank(d) = string(highestcard(d)[1])

function hasduplicate(d)
    s = sort(d)
    for i in 1:length(s)-1
        if s[i] == s[i+1]
            return true
        end
    end
    false
end

invalid(d) = !all(x -> x in sorteddeck, d) || hasduplicate(d)

function countranks(d)
    ranks = Dict()
    for c in d
        r = string(c[1])
        if !haskey(ranks, r)
            ranks[r] = 1
        else
            ranks[r] += 1
        end
    end
    ranks
end

function countsuits(d)
    suits = Dict()
    for c in d
        s = string(c[2])
        if !haskey(suits, s)
            suits[s] = 1
        else
            suits[s] += 1
        end
    end
    suits
end

const rankmodifiers = Dict("A" => 130, "K" => 120, "Q" => 110, "J" => 100, "T" => 90,
                    "9" => 80, "8" => 70, "7" => 60, "6" => 50, "5" => 40,
                    "4" => 30, "3" => 20, "2" => 10)

rank(card) = rankmodifiers[string(card[1])]

const suitmodifiers = Dict("♠" => 4, "♥" => 3, "♦" => 2, "♣" => 1)

suitrank(card) = suitmodifiers[string(card[2])]

function isstraight(ranksdict)
    v = collect(values(ranksdict))
    if maximum(v) != 1
        return false
    else
        s = sort(map(x->rankmodifiers[x], collect(keys(ranksdict))))
        if s == [10, 20, 30, 40, 130]  # aces low straight
            return true
        else
            for i in 1:length(s)-1
                if abs(s[i] - s[i+1]) > 10
                    return false
                end
            end
        end
    end
    true
end

highestsuit(suitsdict) = sort(collect(keys(suitsdict)), lt=(x,y)->suitsdict[x] < suitsdict[y])[end]

isflush(suitsdict) = length(collect(values(suitsdict))) == 1

isstraightflush(ranks, suits) = isstraight(ranks) && isflush(suits)

isfourofakind(ranksdict) = maximum(values(ranksdict)) == 4 ? true : false

isfullhouse(ranksdict) = sort(collect(values(ranksdict))) == [2, 3]

isthreeofakind(ranksdict) = maximum(values(ranksdict)) == 3 && !isfullhouse(ranksdict) ? true : false

istwopair(ranksdict) = sort(collect(values(ranksdict)))[end-1: end] == [2,2]

isonepair(ranksdict) = sort(collect(values(ranksdict)))[end-1: end] == [1,2]

ishighcard(ranks, suits) = maximum(values(ranks)) == 1 && !isflush(suits) && !isstraight(ranks)

function scorehand(d)
    suits = countsuits(d)
    ranks = countranks(d)
    if invalid(d)
        return "invalid"
    end
    if isstraightflush(ranks, suits) return "straight-flush"
    elseif isfourofakind(ranks)      return "four-of-a-kind"
    elseif isfullhouse(ranks)        return "full-house"
    elseif isflush(suits)            return "flush"
    elseif isstraight(ranks)         return "straight"
    elseif isthreeofakind(ranks)     return "three-of-a-kind"
    elseif istwopair(ranks)          return "two-pair"
    elseif isonepair(ranks)          return "one-pair"
    elseif ishighcard(ranks, suits)  return "high-card"
    end
end

const hands =  [["2♥", "2♦", "2♣", "K♣", "Q♦"], ["2♥", "5♥", "7♦", "8♣", "9♠"],
   ["A♥", "2♦", "3♣", "4♣", "5♦"], ["2♥", "3♥", "2♦", "3♣", "3♦"],
   ["2♥", "7♥", "2♦", "3♣", "3♦"], ["2♥", "7♥", "7♦", "7♣", "7♠"],
   ["T♥", "J♥", "Q♥", "K♥", "A♥"], ["4♥", "4♠", "K♠", "5♦", "T♠"],
   ["Q♣", "T♣", "7♣", "6♣", "4♣"]]

for hand in hands
    println("Hand $hand is a ", scorehand(hand), " hand.")
end
