'read UPC barcode Antoni Gual 10/2022  https://rosettacode.org/wiki/UPC

Option Explicit
Const m_limit ="# #"
Const m_middle=" # # "
Dim a,bnum,i,check,odic
a=array("         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",_
         "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",_
        "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",_
          "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",_
        "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",_
       "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",_
        "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",_
         "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",_
        "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",_
         "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ")

'                 0         1         2         3         4          5         6         7         8         9
bnum=Array("0001101","0011001","0010011","0111101","0100011"," 0110001","0101111","0111011","0110111","0001011")

Set oDic = WScript.CreateObject("scripting.dictionary")
For i=0 To 9:
  odic.Add bin2dec(bnum(i),Asc("1")),i+1
  odic.Add bin2dec(bnum(i),Asc("0")),-i-1
Next

For i=0 To UBound(a) : print pad(i+1,-2) & ": "& upc(a(i)) :Next
  WScript.Quit(1)

  Function bin2dec(ByVal B,a) 'binary,ascii of bit 1
    Dim n
    While len(b)
      n =n *2 - (asc(b)=a)  'true is -1 in vbs
      b=mid(b,2)
    Wend
    bin2dec= n And 127
  End Function

  Sub print(s):
    On Error Resume Next
    WScript.stdout.WriteLine (s)
    If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
  End Sub
  function pad(s,n) if n<0 then pad= right(space(-n) & s ,-n) else  pad= left(s& space(n),n) end if :end function

  Function iif(t,a,b)  If t Then iif=a Else iif=b End If :End Function

  Function getnum(s,r) 'get a number from code, check if its's reversed and trim the code
    Dim n,s1,r1
    'returns number or 0 if not found
    s1=Left(s,7)
    s=Mid(s,8)
    r1=r
    Do
      If r Then s1=StrReverse(s1)
      n=bin2dec(s1,asc("#"))
      If odic.exists(n) Then
        getnum=odic(n)
        Exit Function
      Else
        If r1<>r Then getnum=0:Exit Function
        r=Not r
      End If
    Loop
  End Function

  Function getmarker(s,m) 'get a marker and trim the code
    getmarker= (InStr(s,m)= 1)
    s=Mid(s,Len(m)+1)
  End Function

  Function checksum(ByVal s)
    Dim n,i : n=0
    do
       n=n+(Asc(s)-48)*3
       s=Mid(s,2)
       n=n+(Asc(s)-48)*1
       s=Mid(s,2)
    Loop until Len(s)=0
    checksum= ((n mod 10)=0)
  End function

  Function upc(ByVal s1)
    Dim i,n,s,out,rev,j

    'forget about the leading adn trailing spaces, the task says they may be wrong
    s=Trim(s1)
    If getmarker(s,m_limit)=False  Then upc= "bad start marker ":Exit function
    rev=False
    out=""
    For j= 0 To 1
      For i=0 To 5
        n=getnum(s,rev)
        If n=0 Then upc= pad(out,16) & pad ("bad code",-10) & pad("pos "& i+j*6+1,-11): Exit Function
        out=out & Abs(n)-1
      Next
      If j=0 Then If getmarker(s,m_middle)=False  Then upc= "bad middle marker " & out :Exit Function
    Next
    If getmarker(s,m_limit)=False  Then upc= "bad end marker "  :Exit function
    If rev Then out=strreverse(out)
    upc= pad(out,16) &  pad(iif (checksum(out),"valid","not valid"),-10)&  pad(iif(rev,"reversed",""),-11)
  End Function
