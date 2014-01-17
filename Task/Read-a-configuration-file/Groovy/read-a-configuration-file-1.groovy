def config = [:]
def loadConfig = { File file ->
    String regex = /^(;{0,1})\s*(\S+)\s*(.*)$/
    file.eachLine { line ->
        (line =~ regex).each { matcher, invert, key, value ->
            if (key == '' || key.startsWith("#")) return
            parts = value ? value.split(/\s*,\s*/) : (invert ? [false] : [true])
            if (parts.size() > 1) {
                parts.eachWithIndex{ part, int i -> config["$key(${i + 1})"] = part}
            } else {
                config[key] = parts[0]
            }
        }
    }
}
