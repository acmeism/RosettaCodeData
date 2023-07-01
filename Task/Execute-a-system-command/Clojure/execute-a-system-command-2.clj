user=> (use '[clojure.java.shell :only [sh]])

user=> (sh "ls" "-aul")

{:exit 0,
 :out total 64
drwxr-xr-x  11 zkim  staff    374 Jul  5 13:21 .
drwxr-xr-x  25 zkim  staff    850 Jul  5 13:02 ..
drwxr-xr-x  12 zkim  staff    408 Jul  5 13:02 .git
-rw-r--r--   1 zkim  staff     13 Jul  5 13:02 .gitignore
-rw-r--r--   1 zkim  staff  12638 Jul  5 13:02 LICENSE.html
-rw-r--r--   1 zkim  staff   4092 Jul  5 13:02 README.md
drwxr-xr-x   2 zkim  staff     68 Jul  5 13:15 classes
drwxr-xr-x   5 zkim  staff    170 Jul  5 13:15 lib
-rw-r--r--@  1 zkim  staff   3396 Jul  5 13:03 pom.xml
-rw-r--r--@  1 zkim  staff    367 Jul  5 13:15 project.clj
drwxr-xr-x   4 zkim  staff    136 Jul  5 13:15 src
, :err }
