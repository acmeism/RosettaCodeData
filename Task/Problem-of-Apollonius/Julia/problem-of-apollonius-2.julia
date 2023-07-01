include("module.jl")
using .ApolloniusProblems

let test = [Circle(0.0, 0.0, 1.0), Circle(4.0, 0.0, 1.0), Circle(2.0, 4.0, 2.0)]
    println("The defining circles are: \n - ", join(test, "\n - "))
    println("The internal circle is:\n\t", ApolloniusProblems.solve(test))
    println("The external circle is:\n\t", ApolloniusProblems.solve(test, 1:3))
end
