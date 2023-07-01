Module XMLOutput
    Sub Main()
        Dim charRemarks As New Dictionary(Of String, String)
        charRemarks.Add("April", "Bubbly: I'm > Tam and <= Emily")
        charRemarks.Add("Tam O'Shanter", "Burns: ""When chapman billies leave the street ...""")
        charRemarks.Add("Emily", "Short & shrift")

        Dim xml = <CharacterRemarks>
                      <%= From cr In charRemarks Select <Character name=<%= cr.Key %>><%= cr.Value %></Character> %>
                  </CharacterRemarks>

        Console.WriteLine(xml)
    End Sub
End Module
