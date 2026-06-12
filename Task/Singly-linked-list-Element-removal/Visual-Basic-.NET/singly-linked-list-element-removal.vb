    Module Module1

      Public Class ListEntry
        Public value As String
        Public [next] As ListEntry
      End Class

      Public Head As ListEntry

      ''' <summary>
      ''' Straight translation of Torvalds' tasteless version.
      ''' </summary>
      ''' <param name="entry"></param>
      Sub RemoveListEntryTasteless(entry As ListEntry)

        Dim prev As ListEntry = Nothing
        Dim walk = Head

        ' Walk the list
        While walk IsNot entry
          prev = walk
          walk = walk.next
        End While

        ' Remove the entry by updating the head or the previous entry.
        If prev Is Nothing Then
          Head = entry.next
        Else
          prev.next = entry.next
        End If
      End Sub

      ''' <summary>
      ''' Straight translation of Torvalds' tasteful version.
      ''' </summary>
      ''' <param name="entry"></param>
      Sub RemoveListEntryTastefull(entry As ListEntry)

        Dim indirect = New ListEntry
        indirect.next = Head

        ' Walk the list looking for the thing that points at the thing that we
        ' want to remove.
        While indirect.next IsNot entry
          indirect = indirect.next
        End While

        ' ... and just remove it.
        indirect.next = entry.next

      End Sub

End Module

