import std

// comba solves the general problem for any values in an input array

def comba<T>(arr: [T], k) -> [[T]]:
    let ret = []
    for(arr.length) i:
        if k == 1:
            ret.push([arr[i]])
        else:
            let sub = comba(arr.slice(i+1, -1), k-1)
            for(sub) next:
                next.insert(0, arr[i])
                ret.push(next)
    return ret

print comba([0,1,2,3,4], 3)
print comba(["Crosby", "Stills", "Nash", "Young"], 3)
// Of course once could use combi to index the input array instead
var s = ""
combi(4, 3): s += (map(_) i: ["Crosby", "Stills", "Nash", "Young"][i]) + " "
print s
