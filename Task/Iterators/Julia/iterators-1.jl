using DataStructures

function PrintContainer(iterator)
    iter = Iterators.Stateful(iterator)
    foreach(x -> print(x, ", "), Iterators.take(iter, length(iter) -1))
    foreach(println, Iterators.take(iter, 1))
end

function FirstFourthFifth(iterator)
    iter = Iterators.Stateful(iterator)
    foreach(x -> print(x, ", "), Iterators.take(iter, 1))
    popfirst!(iter); popfirst!(iter)
    foreach(x -> print(x, ", "), Iterators.take(iter, 1))
    foreach(println, Iterators.take(iter, 1))
end

const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
const colors = list("Red", "Orange", "Yellow", "Green", "Blue", "Purple") # this is a linked list

println("All elements:")
PrintContainer(days)
PrintContainer(colors)

println("\nFirst, fourth, and fifth elements:")
FirstFourthFifth(days)
FirstFourthFifth(colors)

println("\nReverse first, fourth, and fifth elements:")
FirstFourthFifth(reverse(days))
FirstFourthFifth(reverse(colors))
