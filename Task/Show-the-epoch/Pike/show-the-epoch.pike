object cal = Calendar.ISO->set_timezone("UTC");
write( cal.Second(0)->format_iso_short() );
