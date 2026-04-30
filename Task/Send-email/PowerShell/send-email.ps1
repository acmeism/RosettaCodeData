[hashtable]$mailMessage = @{
    From = "weirdBoy@gmail.com"
    To = "anudderBoy@YourDomain.com"
    Cc = "daWaghBoss@YourDomain.com"
    Attachment = "C:\temp\Waggghhhh!_plan.txt"
    Subject = "Waggghhhh!"
    Body = "Wagggghhhhhh!"
    SMTPServer = "smtp.gmail.com"
    SMTPPort = "587"
    UseSsl = $true
    ErrorAction = "SilentlyContinue"
}

Send-MailMessage @mailMessage
