:-  %say
|=  [^ [in=@tas ~] ~]
:-  %noun
  =+  obj=(need (poja in))                              :: try parse to json
  =+  typ=$:(name=@tas age=@ud)                         :: datastructure
  =+  spec=(ot name/so age/ni ~):jo                     :: parsing spec
  ?.  ?=([%o *] obj)                                    :: isnt an object?
    ~
  =+  ^=  o
    %.  %.  (spec obj)                                  :: parse with spec
      need                                              :: panic if failed
    ,typ                                                :: cast to type
  =.  age.o  +(age.o)                                   :: increment its age...
  %:  crip  %:  pojo                                    :: pretty-print result
    (jobe [%name s/name.o] [%age n/(crip <age.o>)] ~)   :: convert back to json
