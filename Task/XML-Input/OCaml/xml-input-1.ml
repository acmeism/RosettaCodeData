# #directory "+xml-light" (* or maybe "+site-lib/xml-light" *) ;;
# #load "xml-light.cma" ;;

# let x = Xml.parse_string "
  <Students>
    <Student Name='April' Gender='F' DateOfBirth='1989-01-02' />
    <Student Name='Bob' Gender='M'  DateOfBirth='1990-03-04' />
    <Student Name='Chad' Gender='M'  DateOfBirth='1991-05-06' />
    <Student Name='Dave' Gender='M'  DateOfBirth='1992-07-08'>
      <Pet Type='dog' Name='Rover' />
    </Student>
    <Student DateOfBirth='1993-09-10' Gender='F' Name='&#x00C9;mily' />
  </Students>"
  in
  Xml.iter (function
    Xml.Element ("Student", attrs, _) ->
       List.iter (function ("Name", name) -> print_endline name | _ -> ()) attrs
  | _ -> ()) x
  ;;
April
Bob
Chad
Dave
&#x00C9;mily
- : unit = ()
