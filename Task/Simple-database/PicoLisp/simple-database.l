#!/usr/bin/pil

(de usage ()
   (prinl
      "Usage:^J\
      sdb <file> add <title> <cat> <date> ...  Add a new entry^J\
      sdb <file> get <title>                   Retrieve an entry^J\
      sdb <file> latest                        Print the latest entry^J\
      sdb <file> categories                    Print the latest for each cat^J\
      sdb <file>                               Print all, sorted by date" ) )

(de printEntry (E)
   (apply println (cdddr E) (car E) (cadr E) (datStr (caddr E))) )

(ifn (setq *File (opt))
   (usage)
   (case (opt)
      (add
         (let (Ttl (opt)  Cat (opt))
            (if (strDat (opt))
               (rc *File Ttl (cons Cat @ (argv)))
               (prinl "Bad date") ) ) )
      (get
         (let Ttl (opt)
            (when (rc *File Ttl)
               (printEntry (cons Ttl @)) ) ) )
      (latest
         (printEntry (maxi caddr (in *File (read)))) )
      (categories
         (for Cat (by cadr group (in *File (read)))
            (printEntry (maxi caddr Cat)) ) )
      (NIL
         (mapc printEntry (by caddr sort (in *File (read)))) )
      (T (usage)) ) )

(bye)
