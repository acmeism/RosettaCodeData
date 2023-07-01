import "random" for Random

class BestShuffle {
    static shuffle_(ca) {
        var rand = Random.new()
        var i = ca.count - 1
        while (i >= 1) {
            var r = rand.int(i + 1)
            var tmp = ca[i]
            ca[i] = ca[r]
            ca[r] = tmp
            i = i - 1
        }
    }

    static count_(ca, s1) {
        var count = 0
        for (i in 0...ca.count) if (s1[i] == ca[i]) count = count + 1
        return count
    }

    static invoke(s1) {
        var s2 = s1.toList
        shuffle_(s2)
        for (i in 0...s2.count) {
            if (s2[i] == s1[i]) {
                for (j in 0...s2.count) {
                    if (s2[i] != s2[j] && s2[i] != s1[j] && s2[j] != s1[i]) {
                        var tmp = s2[i]
                        s2[i] = s2[j]
                        s2[j] = tmp
                        break
                    }
                }
            }
        }
        return s1 + ", " + s2.join() + ", (" + "%(count_(s2, s1))" + ")"
    }
}

var words = ["tree", "abracadabra", "seesaw", "elk", "grrrrrr", "up", "a"]
words.each { |w| System.print(BestShuffle.invoke(w)) }
