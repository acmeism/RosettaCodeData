(let [temp-file (java.io.File/createTempFile "pre" ".suff")]
  ; insert logic here that would use temp-file
  (.delete temp-file))
