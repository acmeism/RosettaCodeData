BEGIN{FS=""
 RS="\x04"#EOF
 getline<"entropy.awk"
 for(i=1;i<=NF;i++)H[$i]++
 for(i in H)E-=(h=H[i]/NF)*log(h)
 print "bytes ",NF," entropy ",E/log(2)
 exit}
