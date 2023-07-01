static void Main(string[] args)
{
    //First of all construct the SMTP client

    SmtpClient SMTP = new SmtpClient("smtp.gmail.com", 587); //I have provided the URI and port for GMail, replace with your providers SMTP details
    SMTP.EnableSsl = true; //Required for gmail, may not for your provider, if your provider does not require it then use false.
    SMTP.DeliveryMethod = SmtpDeliveryMethod.Network;
    SMTP.Credentials = new NetworkCredential("YourUserName", "YourPassword");
    MailMessage Mail = new MailMessage("yourEmail@address.com", "theirEmail@address.com");


    //Then we construct the message

    Mail.Subject = "Important Message";
    Mail.Body = "Hello over there"; //The body contains the string for your email
    //using "Mail.IsBodyHtml = true;" you can put an HTML page in your message body

    //Then we use the SMTP client to send the message

    SMTP.Send(Mail);

    Console.WriteLine("Message Sent");
}
