MustInherit Class Base

   Protected Sub New()

   End Sub

   Public Sub StandardMethod()
       'code
   End Sub

   Public Overridable Sub Method_Can_Be_Replaced()
       'code
   End Sub

   Public MustOverride Sub Method_Must_Be_Replaced()

End Class
