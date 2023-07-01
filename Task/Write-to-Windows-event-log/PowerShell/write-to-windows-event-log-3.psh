   $MessageFreeLula = 'Global unions and union leaders from more than 50 countries came together ' +
      'in Geneva today to stand in solidarity with former Brazilian President Lula, calling for ' +
      'his immediate release from jail and that he be allowed to run in the upcoming elections.'
   New-EventLog -LogName 'Free Lula!' -Source '#FreeLula'
   Limit-EventLog -OverflowAction 'OverWriteAsNeeded' -MaximumSize (64KB*13) -LogName 'Free Lula!'
   Write-EventLog -LogName 'Free Lula!' -Source '#FreeLula' -Message $MessageFreeLula -EventId 13 -EntryType 'Information'
   'SUCCESS: The Lula Livre message (#FreeLula) has been recorded in the "Free Lula!" log event.'
