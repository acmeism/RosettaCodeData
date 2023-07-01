 /* client.cpp

  libftp++ C++ classes for ftplib C ftp library

  compile:
      clang++ -std=c++11 -o client client.cpp -lftp++
*/

#include <iostream>
#include <string>
#include <cstring>
#include <fstream>
#include <sys/stat.h>   // stat
#include <ftplib.h>     // libftp
#include <ftp++.hpp>    // libftp++


/* C++ classes:

   Connection        main ftp connection       (user class)

   ConnectionBase    base class for Connection (internal)

   DataConnection    connection type,          (internal)
                     read bytes from server,
                     write bytes to  server
		
  ConnectionException  custom exception       (thrown by Connection)

 */


/** ftp::Connection class API

data members:
    A Connection instance contains only a pointer as a data member

    {
      protected:
         netbuf * conn;   // pointer to ftplib netbuf struct
    }

member functions:

 connect:

   Connection(const char * host);     // constructor

   void setConnectionMode(Mode mode); // passive or port

   void login(const char * user, const char * password); // Log in

 info:

   const char * getLastResponse();    // last server response

   std::string getSystemType();   // server type

   std::string getDirectory();  // remote pwd

   void getList(const char * filename, const char * path);  // short dir list

   unsigned size(const char * path, TransferMode mode);

 file transfer:

    void get(const char * local, const char * remote, TransferMode mode);

    void put(const char * local, const char * remote, TransferMode mode);

**/

// libc functions
int stat(const char *pathname, struct stat *buf); // local file info
char *strerror(int errnum);  // explanation of error
char *basename(char *path);  // filename at end of path


// STL  classes and functions used
namespace stl
{
  using std::cout;           // stdout
  using std::cerr;           // stderr
  using std::string;         // string
  using std::ifstream;       // files on disk
  using std::remove;         // delete file on disk
};

using namespace stl;


// connection modes
using Mode = ftp::Connection::Mode;
Mode PASV  = Mode::PASSIVE;
Mode PORT  = Mode::PORT;

//file transfer modes
using TransferMode  = ftp::Connection::TransferMode;
TransferMode BINARY = TransferMode::BINARY;
TransferMode TEXT   = TransferMode::TEXT;


/* ********************** */
// ftp session parameters
struct session
{
  const string server;  // server name
  const string port;    // usually 21
  const string user;    // username
  const string pass;    // password
  Mode  mode;           // PASV, PORT
  TransferMode txmode;  // BINARY, TEXT
  string dir;           // current or default dir
};

/* ********************** */
// local helper functions

ftp::Connection connect_ftp( const session& sess);
size_t get_ftp( ftp::Connection& conn, string const& path);
string readFile( const string& filename);
string login_ftp(ftp::Connection& conn, const session& sess);
string dir_listing( ftp::Connection& conn, const string& path);


/* ******************************** */
// Read a file into one long string

string readFile( const string& filename)
{
  struct stat stat_buf;
  string contents;

  errno = 0;
  if (stat(filename.c_str() , &stat_buf) != -1) // file stats
    {
      size_t len = stat_buf.st_size;            // size of file

      string bytes(len+1, '\0');                // string big enough

      ifstream ifs(filename); // open for input

      ifs.read(&bytes[0], len);  // read all bytes as chars into string

      if (! ifs.fail() ) contents.swap(bytes);  // swap into contents

      ifs.close();
   }
  else
    {
      cerr << "stat error: " << strerror(errno);
    }

  return contents;
}

/* *************** */
// start a session

ftp::Connection connect_ftp( const session& sess)
  try
    {
      string constr = sess.server + ":" + sess.port;

      cerr << "connecting to " << constr << " ...\n";

      ftp::Connection conn{ constr.c_str() };

      cerr << "connected to " << constr << "\n";
      conn.setConnectionMode(sess.mode);

      return conn;
   }
  catch (ftp::ConnectException e)
    {
      cerr << "FTP error: could not connect to server" << "\n";
    }

/* ***** */
// login

string login_ftp(ftp::Connection& conn, const session& sess)
{
  conn.login(sess.user.c_str() , sess.pass.c_str() );

  return conn.getLastResponse();
}

/* ***************************** */
// get remote directory listing

    //   ftplib writes to file for dir contents
    //   convert file contents to string

string dir_listing( ftp::Connection& conn, const string& path)
try
  {
      // file on disk to write to
      const char* dirdata = "/dev/shm/dirdata";

      conn.getList(dirdata, path.c_str() );
      // conn.getFullList(dirdata, path.c_str() );
      // conn.getFullList(NULL, path.c_str() ); // to stdout

      string dir_string = readFile(dirdata);

      cerr << conn.getLastResponse() << "\n";

      errno = 0;
      if ( remove(dirdata) != 0 ) // delete file on disk
      	{
	  cerr << "error: " <<  strerror(errno) << "\n";
      	}

      return dir_string;
  }
 catch (...) {
    cerr << "error: getting dir contents: \n"
	 << strerror(errno) << "\n";
  }

/* ************************* */
// retrieve file from server

size_t get_ftp( ftp::Connection& conn, const string& r_path)
{
  size_t received = 0;

  const char* path = r_path.c_str();

  unsigned remotefile_size = conn.size(path , BINARY);

  const char* localfile = basename(path);

  conn.get(localfile, path, BINARY);  // get file

  cerr << conn.getLastResponse() << "\n";

  // get local file size
  struct stat stat_buf;

  errno = 0;
  if (stat(localfile, &stat_buf) != -1)
     received = stat_buf.st_size;
  else
    cerr << strerror(errno);

  return received;
}

/* ******************** */
// default test session
const session sonic
{
    "mirrors.sonic.net",
    "21" ,
    "anonymous",
    "xxxx@nohost.org",
    PASV,
    BINARY,
    "/pub/OpenBSD"
    };

/* **** */
// main

int main(int argc, char* argv[], char * env[] )
{
  const session remote = sonic;  // copy session info

  try
    {

      // open an ftp connection
      ftp::Connection conn = connect_ftp(remote);

      // login with username and passwd
      cerr << login_ftp(conn, remote);

      // what type system
      cout << "System type: " << conn.getSystemType() << "\n";
      cerr << conn.getLastResponse() << "\n";

      // cd to default session dir
      conn.cd(remote.dir.c_str());  // change to dir on server
      cerr << conn.getLastResponse() << "\n";

      // get current remote  directory
      string pwdstr = conn.getDirectory();
      cout << "PWD: " << pwdstr << "\n";
      cerr << conn.getLastResponse() << "\n";


      // get file listing
      string dirlist = dir_listing(conn, pwdstr.c_str() );
      cout << dirlist << "\n";

      string filename = "ftplist";       // small text file

      auto pos = dirlist.find(filename); // find filename in dir list

      auto notfound = string::npos;

      if (pos != notfound)  // found filename
	{
	  // get file
	  size_t received = get_ftp(conn, filename.c_str() );

	  if (received == 0)
	    cerr << "got 0 bytes\n";
	  else
	    cerr << "got " << filename
		 << " ("   << received << " bytes)\n";
	}
      else
	{
	  cerr << "file " << filename
	       << "not found on server. \n";
	}

    }
    catch (ftp::ConnectException e)
      {
        cerr << "FTP error: could not connect to server" << "\n";
      }
    catch (ftp::Exception e)
      {
        cerr << "FTP error: " << e << "\n";
      }
    catch (...)
      {
        cerr << "error: " <<  strerror(errno) << "\n";
      }

  // logout, connection closes automatically when conn destructs

  return 0;
}
/* END */
