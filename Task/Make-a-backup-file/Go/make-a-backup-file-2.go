package main

import (
    "fmt"
    "io"
    "os"
)

func main() {
    err := updateWithBackup("myth", ".backup", func(f *os.File) (err error) {
        if _, err = f.Seek(0, os.SEEK_SET); err != nil {
            return
        }
        if err = f.Truncate(0); err != nil {
            return
        }
        _, err = f.WriteString("you too!\n")
        return
    })
    if err != nil {
        fmt.Println(err)
    }
}

// updateWithBackup opens fn, creates a backup copy named fn+bx, then passes
// the still-open original file to the supplied function up.  up should
// update the file as needed and return any error, but should not close
// the file.  updateWithBackup will then close the file and return any error.
func updateWithBackup(fn, bx string, up func(*os.File) error) (err error) {
    var f *os.File
    if f, err = openWithBackup(fn, bx); err != nil {
        return
    }
    err = up(f)
    if cErr := f.Close(); err == nil {
        err = cErr
    }
    return
}

// openWithBackup opens fn, creates a backup copy, and returns fn still open.
// If fn is a symlink, the destination file is opened instead.  The name of
// the backup file will be fn+bx, or if fn was a symlink, the name of the
// destination file + bx.  Any error encountered is returned.  tf will be
// an open file if and only if err == nil.
func openWithBackup(fn, bx string) (tf *os.File, err error) {
    // follow symlink.
    if target, err := os.Readlink(fn); err == nil {
        fn = target
    }
    // open the target file for exclusive access.
    if tf, err = os.OpenFile(fn, os.O_RDWR, 0); err != nil {
        return
    }
    // deferred function closes target file if an error happens
    // during the backup operation.
    defer func() {
        if err != nil {
            tf.Close()
        }
    }()
    // stat to preserve permissions.
    var fi os.FileInfo
    if fi, err = tf.Stat(); err != nil {
        return
    }
    // create backup file, silently droping any existing backup.
    var bf *os.File
    if bf, err = os.OpenFile(fn+bx, os.O_RDWR|os.O_CREATE|os.O_TRUNC,
        fi.Mode().Perm()); err != nil {
        return
    }
    // copy contents.  hold on to any error.
    _, err = io.Copy(bf, tf)
    // do your best to close backup file whether copy worked or not.
    if cErr := bf.Close(); err == nil {
        err = cErr // return close error if there has been no other error.
    }
    // backup complete (as long as err == nil)
    return
}
