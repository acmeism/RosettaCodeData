// Gets the first filesystem root.  On most systems this will be / or c:\
def fsRoot = File.listRoots().first()

// Create our list of files (including directories)
def files = [
        new File("input.txt"),
        new File(fsRoot, "input.txt"),
        new File("docs"),
        new File(fsRoot, "docs")
]

/*
We use it.directory to determine whether each file is a regular file or directory.  If it is a directory, we delete
it with deleteDir(), otherwise we just use delete().
 */
files.each{
    it.directory ? it.deleteDir() : it.delete()
}
