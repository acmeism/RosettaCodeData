Aamrun $ sftp demo@test.rebex.net
Password:
Connected to test.rebex.net.
sftp> ls
pub         readme.txt
sftp> cd pub
sftp> ls
example
sftp> ls example
example/KeyGenerator.png         example/KeyGeneratorSmall.png    example/ResumableTransfer.png    example/WinFormClient.png        example/WinFormClientSmall.png   example/imap-console-client.png  example/mail-editor.png          example/mail-send-winforms.png
example/mime-explorer.png        example/pocketftp.png            example/pocketftpSmall.png       example/pop3-browser.png         example/pop3-console-client.png  example/readme.txt               example/winceclient.png          example/winceclientSmall.png
sftp> cd example
sftp> get KeyGenerator.png
Fetching /pub/example/KeyGenerator.png to KeyGenerator.png
/pub/example/KeyGenerator.png                                                                                                                                                                                                               100%   36KB 146.4KB/s   00:00
sftp> exit
Aamrun$
