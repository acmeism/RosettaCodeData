isin? = fn str ->
          if str =~ ~r/\A[A-Z]{2}[A-Z0-9]{9}\d\z/ do
            String.codepoints(str)
            |> Enum.map_join(&String.to_integer(&1, 36))
            |> Luhn.valid?
          else
            false
          end
        end

IO.puts "    ISIN        Valid?"
~w(US0378331005
   US0373831005
   U50378331005
   US03378331005
   AU0000XVGZA3
   AU0000VXGZA3
   FR0000988040)
|> Enum.each(&IO.puts "#{&1}\t#{isin?.(&1)}")
