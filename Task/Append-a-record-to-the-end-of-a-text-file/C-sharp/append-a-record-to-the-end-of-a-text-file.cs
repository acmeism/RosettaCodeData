using System;
using System.IO;

namespace AppendPwdRosetta
{
    class PasswordRecord
    {
        public string account, password, fullname, office, extension, homephone, email, directory, shell;
        public int UID, GID;
        public PasswordRecord(string account, string password, int UID, int GID, string fullname, string office, string extension, string homephone,
            string email, string directory, string shell)
        {
            this.account = account; this.password = password; this.UID = UID; this.GID = GID; this.fullname = fullname; this.office = office;
            this.extension = extension; this.homephone = homephone; this.email = email; this.directory = directory; this.shell = shell;
        }
        public override string ToString()
        {
            var gecos = string.Join(",", new string[] { fullname, office, extension, homephone, email });
            return string.Join(":", new string[] { account, password, UID.ToString(), GID.ToString(), gecos, directory, shell });
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            var jsmith = new PasswordRecord("jsmith", "x", 1001, 1000, "Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org",
                "/home/jsmith", "/bin/bash");
            var jdoe = new PasswordRecord("jdoe", "x", 1002, 1000, "Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org", "/home/jdoe",
                "/bin/bash");
            var xyz = new PasswordRecord("xyz", "x", 1003, 1000, "X Yz", "Room 1003", "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org", "/home/xyz", "/bin/bash");

            // Write these records out in the typical system format.
            File.WriteAllLines("passwd.txt", new string[] { jsmith.ToString(), jdoe.ToString() });

            // Append a new record to the file and close the file again.
            File.AppendAllText("passwd.txt", xyz.ToString());

            // Open the file and demonstrate the new record has indeed written to the end.
            string[] lines = File.ReadAllLines("passwd.txt");
            Console.WriteLine("Appended record: " + lines[2]);
        }
    }
}
