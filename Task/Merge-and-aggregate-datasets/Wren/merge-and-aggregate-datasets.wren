import "/fmt" for Fmt
import "/sort" for Sort

class Patient {
    construct new(id, lastName) {
        _id = id
        _lastName = lastName
        if (!__dir) __dir = {}
        __dir[id] = lastName
        if (!__ids) {
            __ids = [id]
        } else {
            __ids.add(id)
            Sort.insertion(__ids)
        }
    }

    id       { _id }
    lastName { _lastName }

    // maps an id to a lastname
    static dir { __dir }

    // maintains a sorted list of ids
    static ids { __ids }
}

class Visit {
    construct new(id, date, score) {
        _id = id
        _date = date || "0000-00-00"
        _score = score
        if (!__dir) __dir = {}
        if (!__dir[id]) {
            __dir[id] = [ [_date], [score] ]
        } else {
            __dir[id][0].add(_date)
            __dir[id][1].add(score)
        }
    }

    id    { _id }
    date  { _date }
    score { _score }

     // maps an id to lists of dates and scores
    static dir { __dir }
}

class Merge {
    construct new(id) {
        _id = id
    }

    id        { _id }
    lastName  { Patient.dir[_id] }
    dates     { Visit.dir[_id][0] }
    scores    { Visit.dir[_id][1] }
    lastVisit { Sort.merge(dates)[-1] }

    scoreSum  { scores.reduce(0) { |acc, s| s ? acc + s : acc } }
    scoreAvg  { scoreSum / scores.count { |s| s } }

    static print(merges) {
        System.print("| PATIENT_ID | LASTNAME | LAST_VISIT | SCORE_SUM | SCORE_AVG |")
        var fmt = "| $d       | $-7s  | $s | $4s      | $4s      |"
        for (m in merges) {
            if (Visit.dir[m.id]) {
                var lv = (m.lastVisit != "0000-00-00") ? m.lastVisit : "          "
                var ss = (m.scoreSum > 0) ? Fmt.f(4, m.scoreSum, 1) : "    "
                var sa = (!m.scoreAvg.isNan) ? Fmt.f(4, m.scoreAvg, 2) : "    "
                Fmt.print(fmt, m.id, m.lastName, lv, ss, sa)
            } else {
                Fmt.print(fmt, m.id, m.lastName, "          ", "    ", "    ")
            }
        }
    }
}

Patient.new(1001, "Hopper")
Patient.new(4004, "Wirth")
Patient.new(3003, "Kemeny")
Patient.new(2002, "Gosling")
Patient.new(5005, "Kurtz")

Visit.new(2002, "2020-09-10", 6.8)
Visit.new(1001, "2020-09-17", 5.5)
Visit.new(4004, "2020-09-24", 8.4)
Visit.new(2002, "2020-10-08", null)
Visit.new(1001,  null       , 6.6)
Visit.new(3003, "2020-11-12", null)
Visit.new(4004, "2020-11-05", 7.0)
Visit.new(1001, "2020-11-19", 5.3)

var merges = Patient.ids.map { |id| Merge.new(id) }.toList
Merge.print(merges)
