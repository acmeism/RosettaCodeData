func list(s: Any...) -> [Any]
{
    return s
}

func flatten<T>(array: [Any]) -> [T]
{
    var result: [T] = []
    var workstack: [(array: [Any], lastIndex: Int)] = [(array, 0)]

    workstackLoop: while !workstack.isEmpty
    {
        for element in workstack.last!.array.suffixFrom(workstack.last!.lastIndex)
        {
            workstack[workstack.endIndex - 1].lastIndex++

            if let element = element as? [Any]
            {
                workstack.append((element, 0))

                continue workstackLoop
            }

            result.append(element as! T)
        }

        workstack.removeLast()
    }

    return result
}

let input = list(list(1),
    2,
    list(list(3, 4), 5),
    list(list(list())),
    list(list(list(6))),
    7,
    8,
    list()
)

print(input)

let result: [Int] = flatten(input)

print(result)
