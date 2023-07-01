Dim xml = <Students>
              <Student Name="April"/>
              <Student Name="Bob"/>
              <Student Name="Chad"/>
              <Student Name="Dave"/>
              <Student Name="Emily"/>
           </Students>

Dim names = (From node In xml...<Student> Select node.@Name).ToArray

For Each name In names
     Console.WriteLine(name)
Next
