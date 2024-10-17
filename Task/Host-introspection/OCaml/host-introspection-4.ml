(* Reading all the lines from a file.
If the loop is implemented by a recursive auxiliary function, the try...with breaks
tail recursion if not written carefully *)
let lines name =
  let f = open_in name
  and r = ref []
  in
  (try
     while true do
       r := (input_line f)::!r
     done
   with End_of_file -> close_in f);
  (List.rev !r)
;;

# lines "/proc/meminfo";;
- : string list =
["MemTotal:      2075240 kB"; "MemFree:        469964 kB";
 "Buffers:         34512 kB"; "Cached:        1296380 kB";
 "SwapCached:         96 kB"; "Active:         317484 kB";
 "Inactive:      1233500 kB"; "HighTotal:     1178432 kB";
 "HighFree:        45508 kB"; "LowTotal:       896808 kB";
 "LowFree:        424456 kB"; "SwapTotal:     2650684 kB";
 "SwapFree:      2650588 kB"; "Dirty:             228 kB";
 "Writeback:           0 kB"; "AnonPages:      220036 kB";
 "Mapped:          67160 kB"; "Slab:            41540 kB";
 "SReclaimable:    34872 kB"; "SUnreclaim:       6668 kB";
 "PageTables:       1880 kB"; "NFS_Unstable:        0 kB";
 "Bounce:              0 kB"; "WritebackTmp:        0 kB";
 "CommitLimit:   3688304 kB"; "Committed_AS:   549912 kB";
 "VmallocTotal:   114680 kB"; "VmallocUsed:      5172 kB";
 "VmallocChunk:   109320 kB"; "HugePages_Total:     0";
 "HugePages_Free:      0"; "HugePages_Rsvd:      0";
 "HugePages_Surp:      0"; "Hugepagesize:     4096 kB"]
