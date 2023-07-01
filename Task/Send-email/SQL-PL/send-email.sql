UPDATE DB CFG FOR myDb USING SMTP_SERVER 'smtp.ibm.com';

CALL UTL_MAIL.SEND ('senderAccount@myDomain.com','recipientAccount@yourDomain.com', 'copy@anotherDomain.com', NULL, 'The subject of the message', 'The content of the message');
