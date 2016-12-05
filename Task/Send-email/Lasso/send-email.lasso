// with a lot of unneeded params.
// sends plain text and html in same email
// simple usage is below
email_send(
	-host = 'mail.example.com',
	-port = 25,
	-timeout = 100,
	-username = 'user.name',
	-password = 'secure_password',
	-priority = 'immediate',
	-to = 'joe@average.com',
	-cc = 'jane@average.com',
	-bcc = 'me@too.com',
	-from = 'lasso@example.com',
	-replyto = 'lassorocks@example.com',
	-sender = 'lasso@example.com',
	-subject = 'Lasso is awesome',
	-body = 'Lasso is awesome, you should try it!',
	-html = '<p>Lasso is <b>awesome</b>, you should try it!</p>',
	-attachments = '/path/to/myFile.txt'
)

// simple usage
// sends plan text email
email_send(
	-host = 'mail.example.com',
	-username = 'user.name',
	-password = 'secure_password',
	-to = 'joe@average.com',
	-from = 'lasso@example.com',
	-subject = 'Lasso is awesome',
	-body = 'Lasso is awesome, you should try it!'
)
