#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(let (NoData 0  NoDataMax -1  NoDataMaxline "!"  TotFile 0  NumFile 0)
   (let InFiles
      (glue ","
         (mapcar
            '((File)
               (in File
                  (while (split (line) "^I")
                     (let (Len (length @)  Date (car @)  TotLine 0  NumLine 0)
                        (for (L (cdr @)  L  (cddr L))
                           (if (> 1 (format (cadr L)))
                              (inc 'NoData)
                              (when (gt0 NoData)
                                 (when (= NoDataMax NoData)
                                    (setq NoDataMaxline (pack NoDataMaxline ", " Date)) )
                                 (when (> NoData NoDataMax)
                                    (setq NoDataMax NoData  NoDataMaxline Date) ) )
                              (zero NoData)
                              (inc 'TotLine (format (car L) 3))
                              (inc 'NumLine) ) )
                        (inc 'TotFile TotLine)
                        (inc 'NumFile NumLine)
                        (tab (-7 -12 -7 3 -9 3 -11 11 -11 11)
                           "Line:" Date
                           "Reject:" (- (/ (dec Len) 2) NumLine)
                           "  Accept:" NumLine
                           "  Line_tot:" (format TotLine 3)
                           "  Line_avg:"
                           (and (gt0 NumLine) (format (*/ TotLine @) 3)) ) ) ) )
               File )
            (argv) ) )
      (prinl)
      (prinl "File(s)  = " InFiles)
      (prinl "Total    = " (format TotFile 3))
      (prinl "Readings = " NumFile)
      (prinl "Average  = " (format (*/ TotFile NumFile) 3))
      (prinl)
      (prinl
         "Maximum run(s) of " NoDataMax
         " consecutive false readings ends at line starting with date(s): " NoDataMaxline ) ) )

(bye)
