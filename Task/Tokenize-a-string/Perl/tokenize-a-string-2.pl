echo "Hello,How,Are,You,Today" | perl -aplF/,/ -e '$" = "."; $_ = "@F";'
