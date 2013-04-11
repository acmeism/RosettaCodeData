def isDirEmpty = { dirName ->
    def dir = new File(dirName)
    dir.exists() && dir.directory && (dir.list() as List).empty
}
