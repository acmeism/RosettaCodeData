def currentDir = new File('.')
def random = new Random()
def subDirName = "dir${random.nextInt(100000)}"
def subDir = new File(subDirName)
subDir.mkdir()
subDir.deleteOnExit()

assert ! isDirEmpty('.')
assert isDirEmpty(subDirName)
