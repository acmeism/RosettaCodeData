import Foundation

let task = NSTask()
task.launchPath = "/usr/bin/say"
task.arguments = ["This is an example of speech synthesis."]
task.launch()
