Imports System.IO

Module Module1

    Class PasswordRecord
        Public account As String
        Public password As String
        Public fullname As String
        Public office As String
        Public extension As String
        Public homephone As String
        Public email As String
        Public directory As String
        Public shell As String
        Public UID As Integer
        Public GID As Integer

        Public Sub New(account As String, password As String, UID As Integer, GID As Integer, fullname As String, office As String, extension As String, homephone As String, email As String, directory As String, shell As String)
            Me.account = account
            Me.password = password
            Me.UID = UID
            Me.GID = GID
            Me.fullname = fullname
            Me.office = office
            Me.extension = extension
            Me.homephone = homephone
            Me.email = email
            Me.directory = directory
            Me.shell = shell
        End Sub

        Public Overrides Function ToString() As String
            Dim gecos = String.Join(",", New String() {fullname, office, extension, homephone, email})
            Return String.Join(":", New String() {account, password, UID.ToString(), GID.ToString(), gecos, directory, shell})
        End Function
    End Class

    Sub Main()
        Dim jsmith As New PasswordRecord("jsmith", "x", 1001, 1000, "Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org", "/home/jsmith", "/bin/bash")
        Dim jdoe As New PasswordRecord("jdoe", "x", 1002, 1000, "Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org", "/home/jdoe", "/bin/bash")
        Dim xyz As New PasswordRecord("xyz", "x", 1003, 1000, "X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org", "/home/xyz", "/bin/bash")

        ' Write these records out in the typical system format.
        File.WriteAllLines("passwd.txt", New String() {jsmith.ToString(), jdoe.ToString()})

        ' Append a new record to the file and close the file again.
        File.AppendAllText("passwd.txt", xyz.ToString())

        ' Open the file and demonstrate the new record has indeed been written to the end.
        Dim lines = File.ReadAllLines("passwd.txt")
        Console.WriteLine("Appended record: {0}", lines(2))
    End Sub

End Module
