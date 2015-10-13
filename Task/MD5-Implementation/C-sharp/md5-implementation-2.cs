System.Security.Cryptography.MD5CryptoServiceProvider x = new System.Security.Cryptography.MD5CryptoServiceProvider();
byte[] bs = System.Text.Encoding.UTF8.GetBytes(password);
bs = x.ComputeHash(bs); //this function is not in the above classdefinition
System.Text.StringBuilder s = new System.Text.StringBuilder();
foreach (byte b in bs)
{
   s.Append(b.ToString("x2").ToLower());
}
password = s.ToString();
