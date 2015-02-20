(doall
  (map println (.dumpAllThreads (java.lang.management.ManagementFactory/getThreadMXBean) false false)))
