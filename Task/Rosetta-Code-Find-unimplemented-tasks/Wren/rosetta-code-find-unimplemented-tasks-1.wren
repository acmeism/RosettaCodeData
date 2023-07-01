/* rc_find_unimplemented_tasks.wren */

import "./pattern" for Pattern

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

var findTasks = Fn.new { |category|
    var url = "https://www.rosettacode.org/m/api.php?action=query&list=categorymembers&cmtitle=Category:%(category)&cmlimit=500&format=xml"
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

var tasks1 = findTasks.call("Programming_Tasks") // 'full' tasks only
var tasks2 = findTasks.call("Draft_Programming_Tasks")
var lang = "Wren"
var langTasks = findTasks.call(lang) // includes draft tasks
curl.easyCleanup()
System.print("Unimplemented 'full' tasks in %(lang):")
for (task in tasks1) {
    if (!langTasks.contains(task)) System.print("  " + task)
}
System.print("\nUnimplemented 'draft' tasks in %(lang):")
for (task in tasks2) {
    if (!langTasks.contains(task)) System.print("  " + task)
}
