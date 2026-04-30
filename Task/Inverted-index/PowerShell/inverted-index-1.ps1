function Index-File ( [string[]]$FileList )
    {
    #  Create index hashtable, as needed
    If ( -not $Script:WordIndex ) { $Script:WordIndex = @{} }

    #  For each file to be indexed...
    ForEach ( $File in $FileList )
        {
        #  Find any previously existing entries for this file
        $ExistingEntries = $Script:WordIndex.Keys | Where { $Script:WordIndex[$_] -contains $File }

        #  For any previously existing entries
        #    Delete them (prior to reindexing the file)
        ForEach ( $Key in $ExistingEntries )
            {
            $Script:WordIndex[$Key] = @( $Script:WordIndex[$Key] | Where { $_ -ne $File } )
            }

        #  Get the contents of the file, split on non-alphanumeric characters, and remove duplicates
        $Words = ( Get-Content $File ) -split '[^a-zA-Z\d]' | Sort -Unique

        #  For each word in the file...
        ForEach ( $Word in $Words )
            {
            #  If the entry for the word already exists...
            If ( $Script:WordIndex[$Word] )
                {
                #  Add the file name to the entry
                $Script:WordIndex[$Word] += $File
                }
            Else
                {
                #  Create a new entry
                $Script:WordIndex[$Word] = @( $File )
                }
            }
        }
    }

function Find-Word ( [string]$Word )
    {
    return $WordIndex[$Word]
    }
