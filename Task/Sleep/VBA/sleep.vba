Function Sleep(iSecsWait As Integer)
Debug.Print Now(), "Sleeping..."
Application.Wait Now + iSecsWait / 86400 'Time is stored as fractions of 24 hour day
Debug.Print Now(), "Awake!"
End Function
