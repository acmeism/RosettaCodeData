Module TowersOfHanoi
    Sub MoveTowerDisks(ByVal disks As Integer, ByVal fromTower As Integer, ByVal toTower As Integer, ByVal viaTower As Integer)
        If disks > 0 Then
            MoveTowerDisks(disks - 1, fromTower, viaTower, toTower)
            System.Console.WriteLine("Move disk {0} from {1} to {2}", disks, fromTower, toTower)
            MoveTowerDisks(disks - 1, viaTower, toTower, fromTower)
        End If
    End Sub

    Sub Main()
        MoveTowerDisks(4, 1, 2, 3)
    End Sub
End Module
