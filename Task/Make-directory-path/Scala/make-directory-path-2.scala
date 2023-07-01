import java.io.File

def mkdirs(path: List[String]) = // return true if path was created
    path.tail.foldLeft(new File(path.head)){(a,b) => a.mkdir; new File(a,b)}.mkdir

mkdirs(List("/path", "to", "dir"))
