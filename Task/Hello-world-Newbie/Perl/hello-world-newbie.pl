=head1 Obtaining perl

On the majority of UNIX and UNIX-like operating systems
(Linux, Solaris, AIX, HPUX, et cetera), perl will already be installed.
Mac OS X also ships with perl.
Note that "Perl" refers to the language
while "perl" refers to the interpreter used to run Perl programs.

Windows does not ship with perl. Instead, you will have to install one of
the following perl distributions:

=over 4

=item Strawberry Perl

L<Strawberry Perl|http://strawberryperl.com/>: A 100% Open Source Perl for
Windows that is exactly the same as Perl everywhere else; this includes using
modules from CPAN, without the need for binary packages.

=item DWIM Perl for Windows

L<DWIM Perl for Windows|http://dwimperl.com/windows.html>: A 100% Open Source
Perl for Windows, based on Strawberry Perl.
It aims to include as many useful CPAN modules as possible.

=item ActiveState Perl

L<http://www.activestate.com/activeperl/downloads>

=back

Links and further instructions on installation can be found on
L<http://www.perl.org/get.html>.

Once perl is installed, the task of printing "Hello, World!" is quite simple.
From the command line, first check if your environment's C<PATH> variable
knows where to find perl.
On most systems, this can be achieved by entering C<which perl>;
if it spits out something like F</usr/bin/perl>, you're good to go!
If it tells you

    which: no perl in (...)

it means you need to add perl to your environment's C<PATH> variable.
This is done on most systems by entering

    export PATH=$PATH:[...]

where [...] is the full path to your perl installation (usually /usr/bin/perl).

If you do not have the C<which> command, you can probably just type C<perl>
to see if it fires up the perl interpreter.
If it does, press Ctrl+D to exit it and proceed.
Otherwise, perform the steps above to add perl to your PATH variable.

Once perl is installed, one-liners can be executed from the command line
by invoking perl with the C<-e> switch.
    $ perl -e 'print "Hello, World!\n";'
To create a script file that's more permanent, it can be put in a text file.
The name can be anything, but F<.pl> is encouraged.
The #!/usr/bin/perl at the beginning is called the shebang line;
if the operating system supports it, it tells where to find the perl interpreter.
If the script is run with C<perl>, this line will be ignored--
this is for invoking the file as an executable.

=cut

#!/usr/bin/perl
print "Hello, World!\n";
