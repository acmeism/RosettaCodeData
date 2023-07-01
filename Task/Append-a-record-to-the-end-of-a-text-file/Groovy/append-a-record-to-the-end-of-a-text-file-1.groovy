class PasswdRecord {
    String account, password, directory, shell
    int uid, gid
    SourceRecord source

    private static final fs = ':'
    private static final fieldNames = ['account', 'password', 'uid', 'gid', 'source', 'directory', 'shell']
    private static final stringFields = ['account', 'password', 'directory', 'shell']
    private static final intFields = ['uid', 'gid']

    PasswdRecord(String line = null) {
        if (!line) return
        def fields = line.split(fs)
        if (fields.size() != fieldNames.size()) {
            throw new IllegalArgumentException(
            "Passwd record must have exactly ${fieldNames.size()} '${fs}'-delimited fields")
        }
        (0..<fields.size()).each { i ->
            switch (fieldNames[i]) {
                case stringFields:    this[fieldNames[i]] = fields[i];            break
                case intFields:       this[fieldNames[i]] = fields[i] as Integer; break
                default /* source */: this.source = new SourceRecord(fields[i]);  break
            }
        }
    }

    @Override String toString() { fieldNames.collect { "${this[it]}${fs}" }.sum()[0..-2] }
}

class SourceRecord {
    String fullname, office, extension, homephone, email

    private static final fs = ','
    private static final fieldNames =
    ['fullname', 'office', 'extension', 'homephone', 'email']

    SourceRecord(String line = null) {
        if (!line) return
        def fields = line.split(fs)
        if (fields.size() != fieldNames.size()) {
            throw new IllegalArgumentException(
            "Source record must have exactly ${fieldNames.size()} '${fs}'-delimited fields")
        }
        (0..<fields.size()).each { i ->
            this[fieldNames[i]] = fields[i]
        }
    }

    @Override String toString() { fieldNames.collect { "${this[it]}${fs}" }.sum()[0..-2] }
}

def appendNewPasswdRecord = {
    PasswdRecord pwr = new PasswdRecord().with { p ->
        (account, password, uid, gid) = ['xyz', 'x', 1003, 1000]
        source = new SourceRecord().with { s ->
            (fullname, office, extension, homephone, email) =
                    ['X Yz', 'Room 1003', '(234)555-8913', '(234)555-0033', 'xyz@rosettacode.org']
            s
        }
        (directory, shell) = ['/home/xyz', '/bin/bash']
        p
    };

    new File('passwd.txt').withWriterAppend { w ->
        w.append(pwr as String)
        w.append('\r\n')
    }
}
