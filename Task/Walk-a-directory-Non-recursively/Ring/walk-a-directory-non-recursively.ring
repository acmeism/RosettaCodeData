###---------------------------------------
### Directory Tree Walk
### Look for FileType for Music and Video

fileType = [".avi", ".mp4", ".mpg", ".mkv", ".mp3", ".wmv" ]

dirList   = []
musicList = []

###---------------------------------------
### Main

    ###-----------------------------------
    ### Start at this directory

    searchVideoMusic("C:\Users\Umberto\")

    see nl +"Number of Music and Videos files: " +len(musicList) +nl +nl
    see musicList
    See nl +"Finished" +nl

###=======================================
### Search for Video and Music files

Func searchVideoMusic(startDir)

    ChDir(startDir + "Music")     ### <<<== add Music subpath C:\Users\Umberto\Music
    listDir( CurrentDir() )

    ChDir(startDir + "Videos")    ### <<<== add Videos subpath C:\Users\Umberto\Videos
    listDir( CurrentDir() )

    for searchDir in dirList      ### Search Directory List for Music and Videos files
        listDir(searchDir)
    next


###==============================
### Find Files in Directory

Func listDir(dirName)

    ChDir(dirName)
    Try
        ###-------------------------------------
        ### Get SubDirectories

        myListSub = Dir( CurrentDir() )
    Catch
        ###-------------------------------------
        ### Error, Couldn't open the directory

        See "ListDir Catch! " + CurrentDir() +" --- "+ cCatchError +nl
        return
    Done

    for x in myListSub
        if x[2]
            thisDir = x[1]

            if thisDir[1] = "."
                ### Do Nothing. Ignore dot.name

            else
                see nl +"Dir: " + CurrentDir() +"\"+ thisDir + nl

                ###----------------------------------------
                ###  Directory Walk add to directory list

                Add( dirList, (CurrentDir() +"\"+  thisDir))
            ok
        else
            thisFile = x[1]

            ###-------------------------------
            ### Add Music or Video file type

            for thisType in fileType
                if ( substr(thisFile, thisType) )             ### <<<== Type of File from List
                     see "         File: " + thisFile + nl
                     Add(musicList, (CurrentDir() +"\"+  thisFile))
                ok
            next
        ok
    next
return

###===============================================
