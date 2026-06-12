bankrun=:1 :0
  'MAX ALLOC TOTAL'=. y
   todo=.(#ALLOC)#1
   whilst. (+./todo)*-. prior-:todo do.
     prior=. todo
     for_p.I.todo do.
       avail=. TOTAL-+/ALLOC
       echo 'currently available: ',":avail
       pALLOC=. p{ALLOC
       pMAX=. p{MAX
       request=. pMAX-pALLOC
       if.(0>request)+.&(+./)request>avail do.
         echo 'unsafe request ',(":request),', skipping ',":p
         continue.
       else.
         echo 'running process ',(":p),', allocating ',":request
       end.
       free=.request u pALLOC
       echo 'process ',(":p),' freeing ',":free
       assert (0<:free) *&(*/) free <: pMAX
       ALLOC=. (pALLOC-free) p} ALLOC
       todo=. 0 p} todo
    end.
  end.
  if.+./todo do.
    echo 'deadlocked processes: ',":I.todo
  end.
  echo 'DONE'
)
