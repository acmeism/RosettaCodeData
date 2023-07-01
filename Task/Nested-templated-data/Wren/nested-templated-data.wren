import "/set" for Set
import "/sort" for Sort

var withPayload // recursive function
withPayload = Fn.new { |template, payload, used|
    return template.map { |item|
        if (item is List) {
            return withPayload.call(item, payload, used)
        } else {
            used.add(item)
            return "'%(payload[item])'"
        }
    }.toList
}

var p = ["Payload#0", "Payload#1", "Payload#2", "Payload#3", "Payload#4", "Payload#5", "Payload#6"]
var t = [[[1, 2], [3, 4, 1], 5]]
var used = []
System.print(withPayload.call(t, p, used))
System.print()
var unused  = Set.new(0..6).except(Set.new(used)).toList
Sort.insertion(unused)
System.print("The unused payloads have indices of %(unused).")
