/* Rosetta_Code_Run_examples.wren */

import "./pattern" for Pattern
import "./str" for Str

class Http {
    // gets the response body, copies it to a string and automatically closes it
    foreign static getBodyText(url)
}

class Html {
    foreign static unescapeString(s)
}

class Stdin {
    foreign static readLine()
}

class IOUtil {
    foreign static writeFile(fileName, text)

    foreign static removeFile(fileName)
}

class Exec {
    foreign static run2(lang, fileName)
    foreign static run3(lang, param, fileName)
}

var p1 = Pattern.new("title/=\"[+1^\"]\"")
var p2 = Pattern.new("cmcontinue/=\"[+1^\"]\"")

var findTasks = Fn.new { |category|
    var url = "https://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:%(category)&cmlimit=500&format=xml"
    var cmcontinue = ""
    var tasks = []
    while (true) {
        var content = Http.getBodyText(url + cmcontinue)
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
var langs = ["go", "perl", "python", "wren"]
while (true) {
    System.write("Enter the exact name of the task : ")
    var task = Stdin.readLine().trim()
    if (!tasks.contains(task)) {
        System.print("Sorry a task with that name doesn't exist.")
    } else {
        task = task.replace(" ", "_")
        var url = "https://rosettacode.org/w/index.php?title=" + task + "&action=edit"
        var page = Http.getBodyText(url).replace("&lt;", "<")
        var lang
        while (true) {
            System.write("Enter the language Go/Perl/Python/Wren : ")
            lang = Str.lower(Stdin.readLine().trim())
            if (langs.contains(lang)) break
            System.print("Sorry that language is not supported.")
        }
        var lang2
        var lang3
        var ext
        if (lang == "go") {
            lang2 = "Go"
            lang3 = "[go|Go|GO]"
            ext   = "go"
        } else if (lang == "perl") {
            lang2 = "Perl"
            lang3 = "[perl|Perl]"
            ext   = "pl"
        } else if (lang == "python") {
            lang2 = "Python"
            lang3 = "[python|Python]"
            ext   = "py"
        } else if (lang == "wren") {
            lang2 = "Wren"
            lang3 = "[wren|Wren]"
            ext   = "wren"
        }
        var fileName = "rc_temp." + ext
        var p1 = Pattern.new("/=/={{header/|%(lang2)}}/=/=")
        var p2 = Pattern.new("<syntaxhighlight lang/=\"%(lang3)\">")
        var p3 = Pattern.new("<//syntaxhighlight>")
        var s = p1.split(page, 1, 0)
        if (s.count > 1) s = p2.split(s[1], 1, 0)
        var preamble = s[0]
        if (s.count > 1) s = p3.split(s[1], 1, 0)
        if (s.count == 1) {
            System.print("No runnable task entry for that language was detected.")
        } else if (lang == "wren" && s[0].contains(" foreign ")) {
            System.print("This is an embedded script which cannot be run automatically at present.")
        } else {
            var source = Html.unescapeString(s[0])
            System.print("\nThis is the source code for the first or only runnable program:\n")
            System.print(source)
            System.write("\nDo you want to run it y/n : ")
            var yn = Stdin.readLine().trim()[0]
            // note that the executable names may differ from the ones I'm currently using
            if (yn == "y" || yn == "Y") {
                IOUtil.writeFile(fileName, source)
                if (lang == "go") {
                    Exec.run3("go", "run", fileName)
                } else if (lang == "perl") {
                    Exec.run2("perl", fileName)
                } else if (lang == "python") {
                    Exec.run2("python3", fileName)
                } else if (lang == "wren") {
                    if (preamble.contains("{{libheader|DOME}}")) {
                        Exec.run2("dome171", fileName)
                    } else if (preamble.contains("{{libheader|Wren-gmp}}")) {
                        Exec.run2("./wren-gmp", fileName)
                    } else if (preamble.contains("{{libheader|Wren-sql}}")) {
                        Exec.run2("./wren-sql", fileName)
                    } else if (preamble.contains("{{libheader|Wren-i64}}")) {
                        Exec.run2("./wren-i64", fileName)
                    } else if (preamble.contains("{{libheader|Wren-linear}}")) {
                        Exec.run2("./wren-linear", fileName)
                    } else if (preamble.contains("{{libheader|Wren-regex}}")) {
                        Exec.run2("./wren-regex", fileName)
                    } else if (preamble.contains("{{libheader|Wren-psieve}}")) {
                        Exec.run2("./wren-psieve", fileName)
                    } else { // Wren-cli
                        Exec.run2("wren4", fileName)
                    }
                }
                IOUtil.removeFile(fileName)
            }
        }
        System.write("\nDo another one y/n : ")
        var yn = Stdin.readLine().trim()[0]
        if (yn != "y" && yn != "Y") return
    }
}
