class Printer {
    construct new(id, ink) {
        _id = id
        _ink = ink
    }

    ink     { _ink }
    ink=(v) { _ink = v }

    print(text) {
        System.write("%(_id): ")
        for (c in text) System.write(c)
        System.print()
        _ink = _ink - 1
    }
}

var ptrMain    = Printer.new("Main   ", 5)
var ptrReserve = Printer.new("Reserve", 5)

var hd = [
    "Humpty Dumpty sat on a wall.",
    "Humpty Dumpty had a great fall.",
    "All the king's horses and all the king's men",
    "Couldn't put Humpty together again."
]

var mg = [
    "Old Mother Goose",
    "When she wanted to wander,",
    "Would ride through the air",
    "On a very fine gander.",
    "Jack's mother came in,",
    "And caught the goose soon,",
    "And mounting its back,",
    "Flew up to the moon."
]

var task = Fn.new { |name|
    var lines = (name == "Humpty Dumpty") ? hd : mg
    for (line in lines) {
        if (ptrMain.ink > 0) {
            ptrMain.print(line)
            Fiber.yield()
        } else if (ptrReserve.ink > 0) {
            ptrReserve.print(line)
            Fiber.yield()
        } else {
            Fiber.abort("ERROR  : Reserve printer ran out of ink in %(name) task.")
        }
    }
}

var rhymes = ["Humpty Dumpty", "Mother Goose"]
var tasks = List.filled(2, null)
for (i in 0..1) {
   tasks[i] = Fiber.new(task)
   tasks[i].call(rhymes[i])
}

while (true) {
    for (i in 0..1) {
        if (!tasks[i].isDone) {
            var error = tasks[i].try()
            if (error) {
                System.print(error)
                return
            }
        }
    }
    if (tasks.all { |task| task.isDone }) return
}
