# v0.6.0

using DataFrames

df = DataFrame(
EmployeeName=["Tyler Bennett", "John Rappl", "George Woltman", "Adam Smith",
"Claire Buckman", "David McClellan", "Rich Holcomb", "Nathan Adams",
"Richard Potter", "David Motsinger", "Tim Sampair", "Kim Arlich", "Timothy Grove"],
EmployeeID = ["E10297", "E21437", "E00127", "E63535", "E39876", "E04242",
"E01234", "E41298", "E43128", "E27002", "E03033", "E10001", "E16398"],
Salary = [32000, 47000, 53500, 18000, 27800, 41500, 49500, 21900, 15900, 19250,
27000, 57000, 29900],
Department = ["D101", "D050", "D101", "D202", "D202", "D101", "D202", "D050",
"D101", "D202", "D101", "D190", "D190"])

# To get only values
function firstnby(n::Int, y::Array, by::Array)
    # Check that each value belong to one and one only class
    if length(y) != length(by); error("y and by must have the same length"); end

    # Initialize resulting dictionary
    rst = Dict{eltype(by), Array{eltype(y)}}()

    # For each class...
    for cl in unique(by)
        # ...select the values of that class...
        i = find(x -> x == cl, by)
        # ...sort them and store them in result...
        rst[cl] = sort(y[i]; rev=true)
        # ...if length is greater than n select only first n elements
        if length(i) > n
            rst[cl] = rst[cl][1:n]
        end
    end
    return rst
end

for (cl, val) in firstnby(3, Array(df[:Salary]), Array(df[:Department]))
    println("$cl => $val")
end

# To get the full row...
function firstnby(n::Int, df::DataFrame, y::Symbol, by::Symbol)
    rst = Dict{eltype(df[by]), DataFrame}()

    for cl in unique(df[by])
        i = find(x -> x == cl, df[by])
        rst[cl] = sort(df[i, :]; cols=order(y; rev=true))
        if length(i) > n
            rst[cl] = rst[cl][1:n, :]
        end
    end
    return rst
end

for (cl, data) in firstnby(3, df, :Salary, :Department)
    println("\n$cl:\n$data")
end
