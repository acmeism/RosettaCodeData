open System

let main() =
  let est = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time")
  let date = DateTime.Parse("March 7 2009 7:30pm -5" )
  let date_est = TimeZoneInfo.ConvertTime( date, est)
  let date2 = date.AddHours(12.0)
  let date2_est = TimeZoneInfo.ConvertTime( date2, est)
  Console.WriteLine( "Original date in local time : {0}", date )
  Console.WriteLine( "Original date in EST        : {0}", date_est )
  Console.WriteLine( "12 hours later in local time: {0}", date2 )
  Console.WriteLine( "12 hours later in EST       : {0}", date2_est )

main()
