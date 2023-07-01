#directory "+xmlm"
#load "xmlm.cmo"
open Xmlm

let str = "
  <Students>
    <Student Name='April' Gender='F' DateOfBirth='1989-01-02' />
    <Student Name='Bob'   Gender='M' DateOfBirth='1990-03-04' />
    <Student Name='Chad'  Gender='M' DateOfBirth='1991-05-06' />
    <Student Name='Dave'  Gender='M' DateOfBirth='1992-07-08'>
      <Pet Type='dog' Name='Rover' />
    </Student>
    <Student DateOfBirth='1993-09-10' Gender='F' Name='&#x00C9;mily' />
  </Students>"


let xi = make_input(`String(0, str))

let () =
  while not(eoi xi) do
    match Xmlm.input xi with
    | `El_start ((_, "Student"), attrs) ->
        List.iter (function ((_, "Name"), name) -> print_endline name | _ -> ()) attrs
    | _ -> ()
  done
