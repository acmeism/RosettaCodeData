# Sample ''pipe I/O'' OPerator declarations #
OP READ = (PAGEIN page)GENLINE:~;
OP WRITE = (PAGEOUT page)YIELDLINE: ~;
OP APPEND = (PAGEAPPEND page)YIELDLINE:~;
