(let (User "Bill"  Pass "T0p5ecRet"  Url "https://www.example.com")
   (in (list 'curl "-u" (pack User ': Pass) Url)
      (while (line)
         (doSomeProcessingWithLine @) ) ) )
