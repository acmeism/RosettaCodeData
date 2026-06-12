using JuMP, GLPK

const nums = Dict(
    "zero"        => 0,   "one"       => 1,     "two"      => 2,    "three"    => 3,
    "four"        => 4,   "five"      => 5,     "six"      => 6,    "seven"    => 7,
    "eight"       => 8,   "nine"      => 9,     "ten"      => 10,   "eleven"   => 11,
    "twelve"      => 12,  "thirteen"  => 13,    "fourteen" => 14,   "fifteen"  => 15,
    "sixteen"     => 16,  "seventeen" => 17,    "eighteen" => 18,   "nineteen" => 19,
    "twenty"      => 20,
)

function coinproblemsolver(text, maxitems=4, verbose=false)
    coin_problem = Model(GLPK.Optimizer)
    for line in strip.(split(text, r"\n\n"))

        # save original version
        oldline = deepcopy(line)

        # ignore short or commented lines
        length(line) < 5 && continue
        line[1] == '#' && continue

        # create the data structures and registration function
        monies = Dict(
            "dollar_coin" => 100, "half_dollar" => 50, "quarter" => 25, "dime" => 10,
            "nickel" => 5, "penny" => 1,
        )
        foreach(d -> (monies["_" * "$d" * "_bill"] = 100 * d), [1, 2, 5, 10, 20, 50, 100, 500, 1000])

        itemnames = String[]
        itemvalues = Int[]

        function register_variables(vars)
            indices = Int[]
            for cap in vars
                idx = findfirst(x -> cap == x, itemnames)
                if !(idx isa Nothing)
                    push!(indices, idx)
                else
                    push!(itemnames, cap)
                    push!(indices, length(itemnames))
                    push!(itemvalues, get(monies, cap, 0))
                end
            end
            return indices
        end


        # set up the optimizer / problem solver
        @variables(coin_problem, begin x[1:maxitems] >= 0 end)


        # Simplify sentence and standardize quantities

        # convert hyphens to spaces, lowercase, newlines to spaces
        line = replace(replace(lowercase(line), "-" => " "), "\n" => " ")

        # fractions/multipliers to parsable forms
        line = replace(line, r"half.dollars?" => "half_dollar")
        line = replace(line, r"\bone\s+half\b" => "0.5")
        line = replace(line, r"\btwice\b" => "two times")

        # convert spelled out number to integer text per nums dictionary
        for p in nums
            line = replace(line, Regex("\\b" * p[1] * "\\b") => string(p[2]))
        end

        # remove plurals of coinage
        line = replace(line, r"(quarter|dime|nickel|dollar|coin|bill)s" => s"\1")
        line = replace(line, "pennies" => "penny")

        # change numerals to quantites and monies
        line = replace(line, r"dollar coin|all dollar" => "dollar_coin")
        line = replace(line, r"\$(\d+) bill" => s"_\1_bill")
        line = replace(line, r"(\d+) dollar bill" => s"_\1_bill")
        line = replace(line, r"((?:\d+\s+)+\d+)" => (s) -> mapreduce(x -> parse(Int, x), +, split(s))) # 20 6 -> 26

        # remove most unparsed words
        line = replace(line, r"\b(the|a|to|of|i|is|that|it|on|you|this|for|but|with|are|have|be|at|or|was|so|if|out|not|he|she|they|has|do|did|does)\b" => "")
        # simplify spacing
        line = replace(line, r"\s+" => " ")

        # Add variables and constraints to the problem
        for m in eachmatch(r"([\d\.]+) (?:times )?as many (\w+) as (\w+)", line)
            indices = register_variables([m[2], m[3]])
            @constraints(coin_problem, begin x[indices[1]] == x[indices[2]] * parse(Float64, m[1]) end)
        end
        for m in eachmatch(r"(\d+) more (\w+) than (\w+)", line)
            indices = register_variables([m[2], m[3]])
            @constraints(coin_problem, begin x[indices[1]] == x[indices[2]] + parse(Int, m[1]) end)
        end
        for m in eachmatch(r"(\d+) less (\w+) than (\w+)", line)
            indices = register_variables([m[2], m[3]])
            @constraints(coin_problem, begin x[indices[1]] == x[indices[2]] - parse(Int, m[1]) end)
        end
        if (m = match(r"same number (\w+), (\w+),? and (\w+)", line)) != nothing
            indices = register_variables(m.captures)
            @constraints(coin_problem, begin
                x[indices[1]] == x[indices[2]]
                x[indices[2]] == x[indices[3]]
            end)
        end
        if (m = match(r"(\d+) (?:\w+ )?(\w+),? consist\D+\$([\d\.]+)\D+\$([\d\.]+)", line)) != nothing
            n1, n2 = Int(round(100 * parse(Float64, m[3]))), Int(round(100 * parse(Float64, m[4])))
            s1, s2 = m[2] * "_costing_" * string(n1), m[2] * "_costing_" * string(n2)
            monies[s1], monies[s2] = n1, n2
            indices = register_variables([s1, s2])
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        if (m = match(r"(\d+) (?:\w+ )?(\w+),? consist\D+([\d\.]+)¢\D+([\d\.]+)¢", line)) != nothing
            n1, n2 = parse(Int, m[3]), parse(Int, m[4])
            s1, s2 = m[2] * "_costing_" * string(n1), m[2] * "_costing_" * string(n2)
            monies[s1], monies[s2] = n1, n2
            indices = register_variables([s1, s2])
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        if (m = match(r"(\d+) (?:coin|bill),? consist(?:s|ing) (\w+) and (\w+)", line)) != nothing
            indices = register_variables([m[2], m[3]])
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        if (m = match(r"(\d+) (?:coin)[^\d\.,]+pocket (\w+) and (\w+)", line)) != nothing
            indices = register_variables([m[2], m[3]])
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        if (m = match(r"(\d+) (?:coin|bill),? consist(?:s|ing) (\w+), (\w+), and (\w+)", line)) != nothing
            indices = register_variables([m[2], m[3], m[4]])
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        if (m = match(r"\$([\d\.]+) ream\D+\$([\d\.]+)\D+(\d+) reams", line)) != nothing
            n1, n2 = Int(round(100 * parse(Float64, m[1]))), Int(round(100 * parse(Float64, m[2])))
            s1, s2 = "ream_costing_" * string(n1), "ream_costing_" * string(n2)
            monies[s1], monies[s2] = n1, n2
            indices = register_variables([s1, s2])
            @constraints(coin_problem, begin sum(x) == parse(Int, m[3]) end)
        end
        if (m = match(r"(?:in my wallet,?|only accepts) (\w+), (\w+),? and (\w+)", line)) != nothing
            indices = register_variables([m.captures[1], m.captures[2], m.captures[3]])
        end
        if (m = match(r"(\d+) coin in (\w+) and (\w+) only", line)) != nothing
            indices = register_variables([m.captures[2], m.captures[3]])
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        if (m = match(r"(\d+) coin (?:total|in all)", line)) != nothing
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        if (m = match(r"(?:had only|in) (\w+) and (\w+)[,\.\?]", line)) != nothing
            indices = register_variables([m.captures[1], m.captures[2]])
        end
        if (m = match(r"(?:sold total|all together,? there) (\d+)", line)) != nothing
            @constraints(coin_problem, begin sum(x) == parse(Int, m[1]) end)
        end
        for m in eachmatch(r"cost \$([\d\.]+) each", line)
            s = "item_costing_" * m.captures[1]
            monies[s] = Int(round(100 * parse(Float64, m.captures[1])))
            register_variables([s])
        end

        # find a total
        m = match(r"add up \$?([\d\.]+)", line)
        if m isa Nothing
            m = match(r"(?:cost stamps|total cost|paid|value|valuing|store made)[^\$]+\$([\d\.]+)", line)
        end
        if m isa Nothing
            m = match(r"(?:total|value of|store made|given)[^\$]+\$([\d\.]+)", line)
        end
        if m isa Nothing
            m = match(r"\$([\d\.]+) (?:coin )?in", line)
        end
        if !(m isa Nothing)
            m1 = m.captures[1][end] == '.' ? m.captures[1][1:end-1] : m.captures[1]
            @constraints(coin_problem, begin
                sum([itemvalues[i] * x[i] for i in 1:length(itemnames)]) == Int(round(100 * parse(Float64, m1)))
            end)
        else
            m = match(r"total (?:amount coin )([\d\.]+)¢", line)
            if !(m isa Nothing)
                @constraints(coin_problem, begin
                    sum([itemvalues[i] * x[i] for i in 1:length(itemnames)]) == parse(Int, m[1])
                end)
            else
                error("Missing or unparsed total funds constraint")
            end
        end


        # set unused x components to 0
        for i in length(itemnames)+1:maxitems
            @constraints(coin_problem, begin x[i] == 0 end)
        end

        # solve
        optimize!(coin_problem)
        verbose && println(line)
        verbose && println(coin_problem)
        print(oldline, "\nAnswer:   ")
        for i in eachindex(itemnames)
            print(rpad(itemnames[i] * "(s)", 10), ": ", rpad(Int(round(JuMP.value(x[i]))), 10))
        end
        println("\n")
        JuMP.empty!(coin_problem)
    end
end

const DATA =  raw"""
If a person has three times as many quarters as dimes and the total amount of money is $5.95,
find the number of quarters and dimes.

A pile of 18 coins consists of pennies and nickels. If the total amount of the coins is 38¢,
find the number of pennies and nickels.

A small child has 6 more quarters than nickels. If the total amount of coins is $3.00,
find the number of nickels and quarters the child has.

A child's bank contains 32 coins consisting of nickels and quarters. If the total amount of
money is $3.80, find the number of nickels and quarters in the bank.

A person has twice as many dimes as she has pennies and three more nickels than pennies. If
the total amount of the coins is $1.97, find the numbers of each type of coin the person has.

In a bank, there are three times as many quarters as half dollars and 6 more dimes than
half dollars. If the total amount of the money in the bank is $4.65, find the number of
each type of coin in the bank.

A person bought 12 stamps consisting of 37¢ stamps and 23¢ stamps. If the cost of the stamps
is $3.74, find the number of each type of the stamps purchased.

A dairy store sold a total of 80 ice cream sandwiches and ice cream bars. If the sandwiches
cost $0.69 each and the bars cost $0.75 each and the store made $58.08, find the number
of each sold.

An office supply store sells college-ruled notebook paper for $1.59 a ream and wide-ruled
notebook paper for $2.29 a ream. If a student purchased 9 reams of notebook paper and
paid $15.71, how many reams of each type of paper did the student purchase?

A clerk is given $75 in bills to put in a cash drawer at the start of a workday. There are
twice as many $1 bills as $5 bills and one less $10 bill than $5 bills. How many of each
type of bill are there?

A person has 8 coins consisting of quarters and dimes. If the total amount of this change
is $1.25, how many of each kind of coin are there?

A person has 3 times as many dimes as he has nickels and 5 more pennies than nickels. If the
total amount of these coins is $1.13, how many of each kind of coin does he have?

A person bought ten greeting cards consisting of birthday cards costing $1.50 each and
anniversary cards costing $2.00 each. If the total cost of the cards was $17.00, find the
number of each kind of card the person bought.

A person has 9 more dimes than nickels. If the total amount of money is $1.20, find the
number of dimes the person has.

A person has 20 bills consisting of $1 bills and $2 bills. If the total amount of money
the person has is $35, find the number of $2 bills the person has.

A bank contains 8 more pennies than nickels and 3 more dimes than nickels. If the total
amount of money in the bank is $3.10, find the number of dimes in the bank.

Your uncle walks in, jingling the coins in his pocket. He grins at you and tells you that you
can have all the coins if you can figure out how many of each kind of coin he is carrying.
You're not too interested until he tells you that he's been collecting those gold-tone
one-dollar coins. The twenty-six coins in his pocket are all dollars and quarters, and they
add up to seventeen dollars in value. How many of each coin does he have?

A collection of 33 coins, consisting of nickels, dimes, and quarters, has a value of $3.30.
If there are three times as many nickels as quarters, and one-half as many dimes as nickels,
how many coins of each kind are there?

A wallet contains the same number of pennies, nickels, and dimes. The coins total $1.44. How
many of each type of coin does the wallet contain?

Suppose Ken has 25 coins in nickels and dimes only and has a total of $1.65. How many of
each coin does he have?

Terry has 2 more quarters than dimes and has a total of $6.80. The number of quarters and dimes
is 38. How many quarters and dimes does Terry have?

In my wallet, I have one-dollar bills, five-dollar bills, and ten-dollar bills. The total
amount in my wallet is $43. I have four times as many one-dollar bills as ten-dollar bills.
All together, there are 13 bills in my wallet. How many of each bill do I have?

Marsha has three times as many one-dollar bills as she does five dollar bills. She has a
total of $32. How many of each bill does she have?

A vending machine has $41.25 in it. There are 255 coins total and the machine only accepts
nickels, dimes and quarters. There are twice as many dimes as nickels. How many of each coin
are in the machine?

Michael had 27 coins in all, valuing $4.50. If he had only quarters and dimes, how many coins
of each kind did he have?

Lucille had $13.25 in nickels and quarters. If she had 165 coins in all, how many of each
type of coin did she have?

Ben has $45.25 in quarters and dimes. If he has 29 less quarters than dimes, how many of each
type of coin does he have?

A person has 12 coins consisting of dimes and pennies. If the total amount of money is $0.30,
how many of each coin are there?
"""

coinproblemsolver(DATA)

