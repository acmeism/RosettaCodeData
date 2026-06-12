#!/usr/bin/swift

import Foundation

print(Process.arguments[1..<Process.arguments.count].joinWithSeparator(" "))
