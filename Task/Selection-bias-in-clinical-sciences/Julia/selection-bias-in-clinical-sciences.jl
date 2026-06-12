using HypothesisTests

@enum TreatmentClass Untreated Irregular Regular

mutable struct Subject
    cum_dose::Float64
    treatment_class::TreatmentClass
    had_covid::Bool
end

function update!(subjects::Vector{Subject}, pcovid = 0.001, pstart = 0.005, pdosing = 0.25, drange = 3:3:9)
    for subj in subjects
        if subj.had_covid
            continue
        elseif rand() < pcovid
            subj.had_covid = true
        elseif subj.cum_dose > 0 && rand() <= pdosing || subj.cum_dose == 0 && rand() <= pstart
            subj.cum_dose += rand(drange)
            subj.treatment_class =
               subj.cum_dose == 0 ? Untreated : subj.cum_dose >= 100 ? Regular : Irregular
        end
    end
end

function run_study(N = 10_000, duration = 180)
    population = [Subject(0.0, Untreated, false) for _ in 1:N]
    unt, unt_covid, irr, irr_covid, reg, reg_covid = 0, 0, 0, 0, 0, 0
    println("Population size $N, daily infection risk 0.1%")
    for day in 1:duration
        update!(population)
        if day % 30 == 0
            println("\nDay $day:")
            unt = count(s -> s.treatment_class == Untreated, population)
            unt_covid = count(s -> (s.treatment_class == Untreated) && s.had_covid, population)
            println("Untreated: N = $unt, with infection = $unt_covid")
            irr = count(s -> s.treatment_class == Irregular, population)
            irr_covid = count(s -> (s.treatment_class == Irregular) && s.had_covid, population)
            println("Irregular Use: N = $irr, with infection = $irr_covid")
            reg = count(s -> s.treatment_class == Regular, population)
            reg_covid = count(s -> (s.treatment_class == Regular) && s.had_covid, population)
            println("Regular Use: N = $reg, with infection = $reg_covid")
        end
        if day == 90
            println("\nAt midpoint, Infection case percentages are:")
            println("  Untreated : ", Float16(100 * unt_covid / unt))
            println("  Irregulars: ", Float16(100 * irr_covid / irr))
            println("  Regulars  : ", Float16(100 * reg_covid / reg))
        end
    end
    println("\nAt study end, Infection case percentages are:")
    println("  Untreated : ", Float16(100 * unt_covid / unt), " of group size of $unt")
    println("  Irregulars: ", Float16(100 * irr_covid / irr), " of group size of $irr")
    println("  Regulars  : ", Float16(100 * reg_covid / reg), " of group size of $reg")
    untreated = [s.had_covid for s in population if s.treatment_class == Untreated]
    irregular = [s.had_covid for s in population if s.treatment_class == Irregular]
    regular = [s.had_covid for s in population if s.treatment_class == Regular]
    println("\n\n   Final statistics:\n")
    @show KruskalWallisTest(untreated, irregular, regular)
end

run_study()
