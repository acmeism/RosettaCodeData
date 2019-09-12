Imports System.Net.Sockets
Imports System.Text
Imports System.Threading

Module Module1

    Class State
        Private ReadOnly client As TcpClient
        Private ReadOnly sb As New StringBuilder

        Public Sub New(name As String, client As TcpClient)
            Me.Name = name
            Me.client = client
        End Sub

        Public ReadOnly Property Name As String

        Public Sub Send(text As String)
            Dim bytes = Encoding.ASCII.GetBytes(String.Format("{0}" & vbCrLf, text))
            client.GetStream().Write(bytes, 0, bytes.Length)
        End Sub
    End Class

    ReadOnly connections As New Dictionary(Of Integer, State)
    Dim listen As TcpListener
    Dim serverThread As Thread

    Sub Main()
        listen = New TcpListener(Net.IPAddress.Parse("127.0.0.1"), 4004)
        serverThread = New Thread(New ThreadStart(AddressOf DoListen))
        serverThread.Start()
    End Sub

    Private Sub DoListen()
        listen.Start()
        Console.WriteLine("Server: Started server")

        Do
            Console.Write("Server: Waiting...")
            Dim client = listen.AcceptTcpClient()
            Console.WriteLine(" Connected")

            ' New thread with client
            Dim clientThread As New Thread(New ParameterizedThreadStart(AddressOf DoClient))

            clientThread.Start(client)
        Loop
    End Sub

    Private Sub DoClient(client As TcpClient)
        Console.WriteLine("Client (Thread: {0}): Connected!", Thread.CurrentThread.ManagedThreadId)
        Dim bytes = Encoding.ASCII.GetBytes("Enter name: ")
        client.GetStream().Write(bytes, 0, bytes.Length)

        Dim done As Boolean
        Dim name As String
        Do
            If Not client.Connected Then
                Console.WriteLine("Client (Thread: {0}): Terminated!", Thread.CurrentThread.ManagedThreadId)
                client.Close()
                Thread.CurrentThread.Abort() ' Kill thread
            End If

            name = Receive(client)
            done = True

            For Each cl In connections
                Dim state = cl.Value
                If state.Name = name Then
                    bytes = Encoding.ASCII.GetBytes("Name already registered. Please enter your name: ")
                    client.GetStream().Write(bytes, 0, bytes.Length)
                    done = False
                End If
            Next
        Loop While Not done

        connections.Add(Thread.CurrentThread.ManagedThreadId, New State(name, client))
        Console.WriteLine(vbTab & "Total connections: {0}", connections.Count)
        Broadcast(String.Format("+++ {0} arrived +++", name))

        Do
            Dim text = Receive(client)
            If text = "/quit" Then
                Broadcast(String.Format("Connection from {0} closed.", name))
                connections.Remove(Thread.CurrentThread.ManagedThreadId)
                Console.WriteLine(vbTab & "Total connections: {0}", connections.Count)
                Exit Do
            End If

            If Not client.Connected Then
                Exit Do
            End If

            Broadcast(String.Format("{0}> {1}", name, text))
        Loop

        Console.WriteLine("Client (Thread: {0}): Terminated!", Thread.CurrentThread.ManagedThreadId)
        client.Close()
        Thread.CurrentThread.Abort()
    End Sub

    Private Function Receive(client As TcpClient) As String
        Dim sb As New StringBuilder
        Do
            If client.Available > 0 Then
                While client.Available > 0
                    Dim ch = Chr(client.GetStream.ReadByte())
                    If ch = vbCr Then
                        ' ignore
                        Continue While
                    End If
                    If ch = vbLf Then
                        Return sb.ToString()
                    End If
                    sb.Append(ch)
                End While

                ' pause
                Thread.Sleep(100)
            End If
        Loop
    End Function

    Private Sub Broadcast(text As String)
        Console.WriteLine(text)
        For Each client In connections
            If client.Key <> Thread.CurrentThread.ManagedThreadId Then
                Dim state = client.Value
                state.Send(text)
            End If
        Next
    End Sub

End Module
