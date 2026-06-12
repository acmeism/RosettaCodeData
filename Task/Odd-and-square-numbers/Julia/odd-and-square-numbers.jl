oddsquares(lim) = [i^2 for i ∈ Int.(range((√).(lim)...)) if isodd(i)]
oddsquares((100, 999))
