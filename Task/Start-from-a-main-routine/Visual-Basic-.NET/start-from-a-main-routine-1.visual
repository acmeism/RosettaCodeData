Imports System.Collections.ObjectModel
Imports Microsoft.VisualBasic.ApplicationServices

Namespace My
    ' The following events are available for MyApplication:
    ' Startup: Raised when the application starts, before the startup form is created.
    ' Shutdown: Raised after all application forms are closed.  This event is not raised if the application terminates abnormally.
    ' UnhandledException: Raised if the application encounters an unhandled exception.
    ' StartupNextInstance: Raised when launching a single-instance application and the application is already active.
    ' NetworkAvailabilityChanged: Raised when the network connection is connected or disconnected.

    Partial Friend Class MyApplication
        '''<summary>Sets the visual styles, text display styles, and current principal for the main application thread
        '''(if the application uses Windows authentication), and initializes the splash screen, if defined.</summary>
        '''<param name="commandLineArgs">A <see cref="ReadOnlyCollection(Of T)" /> of <see langword="String" />,
        '''containing the command-line arguments as strings for the current application.</param>
        '''<returns>A <see cref="T:System.Boolean" /> indicating if application startup should continue.</returns>
        Protected Overrides Function OnInitialize(commandLineArgs As ReadOnlyCollection(Of String)) As Boolean
            Console.WriteLine("oninitialize; args: " & String.Join(", ", commandLineArgs))
            Return MyBase.OnInitialize(commandLineArgs)
        End Function

        ' WindowsFormsApplicationBase.Startup occurs "when the application starts".
        Private Sub MyApplication_Startup(sender As Object, e As StartupEventArgs) Handles Me.Startup
            Console.WriteLine("startup; args: " & String.Join(", ", e.CommandLine))
        End Sub

        '''<summary>Provides the starting point for when the main application is ready to start running, after the
        '''initialization is done.</summary>
        Protected Overrides Sub OnRun()
            Console.WriteLine("onrun")
            MyBase.OnRun()
        End Sub
    End Class
End Namespace
