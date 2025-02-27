import "os" for Process
import "timer" for Now
import "./pattern" for Pattern
import "./ioutil" for Input

var p1 = Pattern.new("title/=\"[+1^\"]\"")
var p2 = Pattern.new("cmcontinue/=\"[+1^\"]\"")

var findTasks = Fn.new { |category|
    var url = "https://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:%(category)&cmlimit=500&format=xml"
    var cmcontinue = ""
    var tasks = []
    while (true) {
        var content = Process.read("curl -s -L \"%(url)%(cmcontinue)\"")
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
var lang = Input.text("Enter the category name of your language: ", 1)
var langTasks = findTasks.call(lang) // includes draft tasks
System.print("\nResults for %(lang) as at %(Now.date):")
System.print("\nUnimplemented 'full' tasks:")
var count = 0
for (task in tasks1) {
    if (!langTasks.contains(task)) {
        System.print("  " + task)
        count = count + 1
    }
}
System.print("   Total = %(count)")
count = 0
System.print("\nUnimplemented 'draft' tasks:")
for (task in tasks2) {
    if (!langTasks.contains(task)) {
        System.print("  " + task)
        count = count + 1
    }
}
System.print("   Total = %(count)")
