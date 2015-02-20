def checkPasswdFile = { it ->
    File passwd = new File('passwd.txt')
    assert passwd.exists()

    passwd.eachLine { line ->
        def pw = new PasswdRecord(line)
        assert pw && pw instanceof PasswdRecord
        assert pw.source && pw.source instanceof SourceRecord
        println pw
    }

    println()
}

println "File contents before new record added"
checkPasswdFile()

appendNewPasswdRecord()

println "File contents after new record added"
checkPasswdFile()
