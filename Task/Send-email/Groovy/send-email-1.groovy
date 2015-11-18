import javax.mail.*
import javax.mail.internet.*

public static void simpleMail(String from, String password, String to,
    String subject, String body) throws Exception {

    String host = "smtp.gmail.com";
    Properties props = System.getProperties();
    props.put("mail.smtp.starttls.enable",true);
    /* mail.smtp.ssl.trust is needed in script to avoid error "Could not convert socket to TLS"  */
    props.setProperty("mail.smtp.ssl.trust", host);
    props.put("mail.smtp.auth", true);
    props.put("mail.smtp.host", host);
    props.put("mail.smtp.user", from);
    props.put("mail.smtp.password", password);
    props.put("mail.smtp.port", "587");

    Session session = Session.getDefaultInstance(props, null);
    MimeMessage message = new MimeMessage(session);
    message.setFrom(new InternetAddress(from));

    InternetAddress toAddress = new InternetAddress(to);

    message.addRecipient(Message.RecipientType.TO, toAddress);

    message.setSubject(subject);
    message.setText(body);

    Transport transport = session.getTransport("smtp");

    transport.connect(host, from, password);

    transport.sendMessage(message, message.getAllRecipients());
    transport.close();
}

/* Set email address sender */
String s1 = "example@gmail.com";

/* Set password sender */
String s2 = "";

/* Set email address sender */
String s3 = "example@gmail.com"

/*Call function */
simpleMail(s1, s2 , s3, "TITLE", "TEXT");
