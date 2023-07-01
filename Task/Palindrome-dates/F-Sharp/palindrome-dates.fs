// palindrome_dates.fsx
open System

let is_palindrome_date =
    let date_string (date: DateTime) = date.ToString "yyyyMMdd"
    let is_palindrome s =
        let rev_string = Seq.rev >> Seq.map string >> String.concat ""
        s = rev_string s
    date_string >> is_palindrome

let palindrome_dates =
    let rec loop date =
        seq {
            if is_palindrome_date date
            then
                yield date
                yield! loop (date.AddDays 1.0)
            else
                yield! loop (date.AddDays 1.0)
        }
    loop DateTime.Now

let print_date =
    let iso_string (date: DateTime) = date.ToString "yyyy-MM-dd"
    iso_string >> printfn "%s"

palindrome_dates
|> Seq.take 15
|> Seq.iter print_date
