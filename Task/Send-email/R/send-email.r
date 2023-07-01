library(RDCOMClient)

send.mail <- function(to, title, body) {
  olMailItem <- 0
  ol <- COMCreate("Outlook.Application")
  msg <- ol$CreateItem(olMailItem)
  msg[["To"]] <- to
  msg[["Subject"]] <- title
  msg[["Body"]] <- body
  msg$Send()
  ol$Quit()
}

send.mail("somebody@somewhere", "Title", "Hello")
