def max = 0
def dates = []
def licenses = [:]
new File('licenseFile.txt').eachLine { line ->
    (line =~ /License (\w+)\s+@ ([\d\/_:]+) for job (\d+)/).each { matcher, action, date, job ->
        switch (action) {
        case 'IN':
            assert licenses[job] != null : "License has not been checked out for $job"
            licenses.remove job
            break
        case 'OUT':
            assert licenses[job] == null : "License has already been checked out for $job"
            licenses[job] = date
            def count = licenses.keySet().size()
            if (count > max) {
                max = count
                dates = [ date ]
            } else if (count == max) {
                dates << date
            }
            break
        default:
            throw new IllegalArgumentException("Unsupported license action $action")
        }
    }
}

println "Maximum Licenses $max"
dates.each { date -> println "  $date" }
