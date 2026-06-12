abstract type CarElementVisitor end

struct CarElementDoVisitor <: CarElementVisitor end
struct CarElementPrintVisitor <: CarElementVisitor end

abstract type CarElement end
struct Body <: CarElement end
struct Engine <: CarElement end

struct Wheel <: CarElement
    name::String
    Wheel(str::String) = new(str)
end

struct Car <:CarElement
    elements::Vector{CarElement}
    Car() = new([Wheel("front left"), Wheel("front right"),
                 Wheel("rear left"), Wheel("rear right"),
                 Body(), Engine()])
end

accept(e::CarElement, visitor::CarElementVisitor) = visit(visitor, e)

function accept(car::Car, visitor::CarElementVisitor)
    for element in car.elements
        accept(element, visitor)
    end
    visit(visitor, car)
end

visit(v::CarElementDoVisitor, e::Body) = println("Moving my body.")
visit(v::CarElementDoVisitor, e::Car) = println("Starting my car.")
visit(v::CarElementDoVisitor, e::Wheel) = println("Kicking my $(e.name) wheel.")
visit(v::CarElementDoVisitor, e::Engine) = println("Starting my engine.")

visit(v::CarElementPrintVisitor, e::Body) = println("Visiting body.")
visit(v::CarElementPrintVisitor, e::Car) = println("Visiting car.")
visit(v::CarElementPrintVisitor, e::Wheel) = println("Visiting $(e.name) wheel.")
visit(v::CarElementPrintVisitor, e::Engine) = println("Visiting engine.")

car = Car()
accept(car, CarElementPrintVisitor())
println()
accept(car, CarElementDoVisitor())
