import posix
import strutils

type

  # GECOS representation.
  Gecos = tuple[fullname, office, extension, homephone, email: string]

  # Record representation.
  Record = object
    account: string
    password: string
    uid: int
    gid: int
    gecos: Gecos
    directory: string
    shell: string

#---------------------------------------------------------------------------------------------------

proc str(gecos: Gecos): string =
  ## Explicit representation of a GECOS.

  result = "("
  for name, field in gecos.fieldPairs:
    result.addSep(", ", 1)
    result.add(name & ": " & field)
  result.add(')')

#---------------------------------------------------------------------------------------------------

proc `$`(gecos: Gecos): string =
  ## Compact representation of a GECOS.

  for field in gecos.fields:
    result.addSep(",", 0)
    result.add(field)

#---------------------------------------------------------------------------------------------------

proc parseGecos(s: string): Gecos =
  ## Parse a string and return a Gecos tuple.

  let fields = s.split(",")
  result = (fields[0], fields[1], fields[2], fields[3], fields[4])

#---------------------------------------------------------------------------------------------------

proc str(rec: Record): string =
  ## Explicit representation of a record.

  for name, field in rec.fieldPairs:
    result.add(name & ": ")
    when typeof(field) is Gecos:
      result.add(str(field))
    else:
      result.add($field)
    result.add('\n')

#---------------------------------------------------------------------------------------------------

proc `$`(rec: Record): string =
  # Compact representation fo a record.

  for field in rec.fields:
    result.addSep(":", 0)
    result.add($field)

#---------------------------------------------------------------------------------------------------

proc parseRecord(line: string): Record =
  ## Parse a string and return a Record object.

  let fields = line.split(":")
  result.account = fields[0]
  result.password = fields[1]
  result.uid = fields[2].parseInt()
  result.gid = fields[3].parseInt()
  result.gecos = parseGecos(fields[4])
  result.directory = fields[5]
  result.shell = fields[6]

#---------------------------------------------------------------------------------------------------

proc getLock(f: File): bool =
  ## Try to get an exclusive write lock on file "f". Return false is unsuccessful.

  when defined(posix):
    var flock = TFlock(l_type: cshort(F_WRLCK), l_whence: cshort(SEEK_SET), l_start: 0, l_len: 0)
    result = f.getFileHandle().fcntl(F_SETLK, flock.addr) >= 0
  else:
    result = true

#———————————————————————————————————————————————————————————————————————————————————————————————————

var pwfile: File

const Filename = "passwd"

const Data = ["jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash",
              "jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash"]

# Prepare initial file.
# We don'’t use a lock here as it is only the preparation.
pwfile = open(FileName, fmWrite)
for line in Data:
  pwfile.writeLine(line)
pwfile.close()

# Display initial contents.
echo "Raw content of initial password file:"
echo "-------------------------------------"
var records: seq[Record]
for line in lines(FileName):
  echo line
  records.add(line.parseRecord())

echo ""
echo "Structured content of initial password file:"
echo "--------------------------------------------"
for rec in records:
  echo str(rec)

# Add a new record at the end of password file.
pwfile = open(Filename, fmAppend)
let newRecord = Record(account: "xyz",
                       password: "x",
                       uid: 1003,
                       gid: 1000,
                       gecos: ("X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org"),
                       directory: "/home/xyz",
                       shell: "/bin/bash")
echo "Appending new record:"
echo "---------------------"
echo str(newRecord)
if pwfile.getLock():
  pwFile.writeLine(newRecord)
  pwfile.close()
else:
  echo "File is locked. Quitting."
  pwFile.close()
  quit(QuitFailure)

# Reopen the file and display its contents.
echo "Raw content of updated password file:"
echo "-------------------------------------"
for line in lines(FileName):
  echo line
