with Ada.Text_IO;
with Sf.Network.Ftp;
with Sf.Network.IpAddress;
with Sf.System.Time;

procedure Main is
   use Sf; use Sf.Network; use Sf.Network.Ftp;
   FTP_Error : exception;

   FTP_Object : constant sfFtp_Ptr := create;

   procedure Check_Response (FTP_Response : sfFtpResponse_Ptr) is
      Message : constant String := Response.getMessage (FTP_Response);
   begin
      Response.destroy (FTP_Response);
      if not Response.isOk (FTP_Response) then
         raise FTP_Error with Message;
      else
         Ada.Text_IO.Put_Line ("OK: " & Message);
      end if;
   end Check_Response;

   procedure List_Directory (Path : String) is
      Response : sfFtpListingResponse_Ptr;
   begin
      Response := getDirectoryListing (FTP_Object, Path);
      if ListingResponse.isOk (Response) then
         for Index in 0 .. ListingResponse.getCount (Response) - 1 loop
            Ada.Text_IO.Put_Line (ListingResponse.getName (Response, Index));
         end loop;
      else
         Ada.Text_IO.Put_Line (ListingResponse.getMessage (Response));
      end if;
      ListingResponse.destroy (Response);
   end List_Directory;

begin

   Check_Response
     (connect (FTP_Object,
               server => IpAddress.fromString ("speedtest.tele2.net"),
               port => 21,
               timeout => Sf.System.Time.sfSeconds (30.0)));

   Check_Response (loginAnonymous (FTP_Object));

   Check_Response (changeDirectory (FTP_Object, "/upload"));
   Check_Response (changeDirectory (FTP_Object, "/"));

   List_Directory (".");

   Check_Response (download (FTP_Object,
                             remoteFile => "100KB.zip",
                             localPath => ".",
                             mode => sfFtpBinary));
   destroy (FTP_Object);
end Main;
