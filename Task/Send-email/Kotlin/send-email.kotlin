// version 1.1.4-3

import java.util.Properties
import javax.mail.Authenticator
import javax.mail.PasswordAuthentication
import javax.mail.Session
import javax.mail.internet.MimeMessage
import javax.mail.internet.InternetAddress
import javax.mail.Message.RecipientType
import javax.mail.Transport

fun sendEmail(user: String, tos: Array<String>, ccs: Array<String>, title: String,
              body: String, password: String) {
    val props = Properties()
    val host = "smtp.gmail.com"
    with (props) {
        put("mail.smtp.host", host)
        put("mail.smtp.port", "587") // for TLS
        put("mail.smtp.auth", "true")
        put("mail.smtp.starttls.enable", "true")
    }
    val auth = object: Authenticator() {
        protected override fun getPasswordAuthentication() =
            PasswordAuthentication(user, password)
    }
    val session = Session.getInstance(props, auth)
    val message = MimeMessage(session)
    with (message) {
        setFrom(InternetAddress(user))
        for (to in tos) addRecipient(RecipientType.TO, InternetAddress(to))
        for (cc in ccs) addRecipient(RecipientType.TO, InternetAddress(cc))
        setSubject(title)
        setText(body)
    }
    val transport = session.getTransport("smtp")
    with (transport) {
        connect(host, user, password)
        sendMessage(message, message.allRecipients)
        close()
    }
}

fun main(args: Array<String>) {
    val user = "some.user@gmail.com"
    val tos = arrayOf("other.user@otherserver.com")
    val ccs = arrayOf<String>()
    val title = "Rosetta Code Example"
    val body = "This is just a test email"
    val password = "secret"
    sendEmail(user, tos, ccs, title, body, password)
}
