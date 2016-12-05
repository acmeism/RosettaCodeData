program sendmail
    use ifcom
    use msoutl
    implicit none
    integer(4) :: app, status, msg

    call cominitialize(status)
    call comcreateobject("Outlook.Application", app, status)
    msg = $Application_CreateItem(app, olMailItem, status)
    call $MailItem_SetTo(msg, "somebody@somewhere", status)
    call $MailItem_SetSubject(msg, "Title", status)
    call $MailItem_SetBody(msg, "Hello", status)
    call $MailItem_Send(msg, status)
    call $Application_Quit(app, status)
    call comuninitialize()
end program
