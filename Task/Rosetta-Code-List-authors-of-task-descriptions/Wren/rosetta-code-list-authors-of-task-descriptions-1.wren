/* Rosetta_Code_List_authors_of_task_descriptions.wren */

import "./pattern" for Pattern
import "./fmt" for Fmt

var CURLOPT_URL = 10002
var CURLOPT_FOLLOWLOCATION = 52
var CURLOPT_WRITEFUNCTION = 20011
var CURLOPT_WRITEDATA = 10001

foreign class Buffer {
    construct new() {}  // C will allocate buffer of a suitable size

    foreign value       // returns buffer contents as a string
}

foreign class Curl {
    construct easyInit() {}

    foreign easySetOpt(opt, param)

    foreign easyPerform()

    foreign easyCleanup()
}

var curl = Curl.easyInit()

var getContent = Fn.new { |url|
    var buffer = Buffer.new()
    curl.easySetOpt(CURLOPT_URL, url)
    curl.easySetOpt(CURLOPT_FOLLOWLOCATION, 1)
    curl.easySetOpt(CURLOPT_WRITEFUNCTION, 0)  // write function to be supplied by C
    curl.easySetOpt(CURLOPT_WRITEDATA, buffer)
    curl.easyPerform()
    return buffer.value
}

var p1 = Pattern.new("title/=\"[+1^\"]\"")
var p2 = Pattern.new("cmcontinue/=\"[+1^\"]\"")
var pi = "\"&"
var p3 = Pattern.new("a href/=\"//[wiki//User:|w//index.php?title/=User:|wiki//Special:Contributions//][+1/I]\"", 0, pi)

var findTasks = Fn.new { |category|
    var url = "https://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:%(category)&cmlimit=500&format=xml"
    var cmcontinue = ""
    var tasks = []
    while (true) {
        var content = getContent.call(url + cmcontinue)
        var matches1 = p1.findAll(content)
        for (m in matches1) {
            var title = m.capsText[0].replace("&#039;", "'").replace("&quot;", "\"")
            tasks.add(title)
        }
        var m2 = p2.find(content)
        if (m2) cmcontinue = "&cmcontinue=%(m2.capsText[0])" else break
    }
    return tasks
}

var tasks = findTasks.call("Programming_Tasks") // 'full' tasks only
tasks.addAll(findTasks.call("Draft_Programming_Tasks"))
var tc = tasks.count
var authors = {}
while (tasks.count > 0) {
    var task = tasks[0].replace(" ", "_").replace("+", "\%2B")
    // check the last or only history page for each task
    var url = "https://rosettacode.org/w/index.php?title=%(task)&dir=prev&action=history"
    tasks.removeAt(0)
    var content = getContent.call(url)
    content = content.replace("http://www.rosettacode.org", "")
    var matches = p3.findAll(content)
    // if there are no matches there must have been a 'bad gateway' or other error
    if (matches.count == 0) {
        // add back a failed task until it eventually succeeds
        tasks.add(task)
        continue
    }
    // the task author should be the final user on that page
    var author = matches[-1].capsText[1].replace("_", " ")
    // add this task to the author's count
    if (authors.containsKey(author)) {
        authors[author] = authors[author] + 1
    } else {
        authors[author] = 1
    }
}

// sort the authors in descending order by number of tasks created
var authorNumbers = authors.toList
authorNumbers.sort { |a, b| a.value > b.value }
// print those who've completed at least 9 tasks
System.print("As at 10th September 2022:\n")
System.print("Total tasks   : %(tc)")
System.print("Total authors : %(authors.count)")
System.print("\nThe authors who have created at least 9 tasks are:\n")
System.print("Pos    Tasks  Author")
System.print("====   =====  ======")
var lastNumber = 0
var lastIndex = -1
var i = 0
for (authorNumber in authorNumbers.where { |me| me.value >= 9 }) {
    var j = i
    var eq = " "
    if (authorNumber.value == lastNumber) {
        j = lastIndex
        eq = "="
    } else {
        lastIndex = i
        lastNumber = authorNumber.value
    }
    Fmt.print("$3d$s    $3d   $s", j+1, eq, authorNumber.value, authorNumber.key)
    i = i + 1
}
curl.easyCleanup()
