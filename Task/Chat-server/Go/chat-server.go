package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"net"
	"strings"
	"time"
)

func main() {
	log.SetPrefix("chat: ")
	addr := flag.String("addr", "localhost:4000", "listen address")
	flag.Parse()
	log.Fatal(ListenAndServe(*addr))
}

// A Server represents a chat server that accepts incoming connections.
type Server struct {
	add  chan *conn  // To add a connection
	rem  chan string // To remove a connection by name
	msg  chan string // To send a message to all connections
	stop chan bool   // To stop early
}

// ListenAndServe listens on the TCP network address addr for
// new chat client connections.
func ListenAndServe(addr string) error {
	ln, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}
	log.Println("Listening for connections on", addr)
	defer ln.Close()
	s := &Server{
		add:  make(chan *conn),
		rem:  make(chan string),
		msg:  make(chan string),
		stop: make(chan bool),
	}
	go s.handleConns()
	for {
		// TODO use AcceptTCP() so that we can get a TCPConn on which
		// we can call SetKeepAlive() and SetKeepAlivePeriod()
		rwc, err := ln.Accept()
		if err != nil {
			// TODO Could handle err.(net.Error).Temporary()
			// here by adding a backoff delay.
			close(s.stop)
			return err
		}
		log.Println("New connection from", rwc.RemoteAddr())
		go newConn(s, rwc).welcome()
	}
}

// handleConns is run as a go routine to handle adding and removal of
// chat client connections as well as broadcasting messages to them.
func (s *Server) handleConns() {
	// We define the `conns` map here rather than within Server,
	// and we use local function literals rather than methods to be
	// extra sure that the only place that touches this map is this
	// method. In this way we forgo any explicit locking needed as
	// we're the only go routine that can see or modify this.
	conns := make(map[string]*conn)

	var dropConn func(string)
	writeAll := func(str string) {
		log.Printf("Broadcast: %q", str)
		// TODO handle blocked connections
		for name, c := range conns {
			c.SetWriteDeadline(time.Now().Add(500 * time.Millisecond))
			_, err := c.Write([]byte(str))
			if err != nil {
				log.Printf("Error writing to %q: %v", name, err)
				c.Close()
				delete(conns, name)
				// Defer all the disconnect messages until after
				// we've closed all currently problematic conns.
				defer dropConn(name)
			}
		}
	}

	dropConn = func(name string) {
		if c, ok := conns[name]; ok {
			log.Printf("Closing connection with %q from %v",
				name, c.RemoteAddr())
			c.Close()
			delete(conns, name)
		} else {
			log.Printf("Dropped connection with %q", name)
		}
		str := fmt.Sprintf("--- %q disconnected ---\n", name)
		writeAll(str)
	}

	defer func() {
		writeAll("Server stopping!\n")
		for _, c := range conns {
			c.Close()
		}
	}()

	for {
		select {
		case c := <-s.add:
			if _, exists := conns[c.name]; exists {
				fmt.Fprintf(c, "Name %q is not available\n", c.name)
				go c.welcome()
				continue
			}
			str := fmt.Sprintf("+++ %q connected +++\n", c.name)
			writeAll(str)
			conns[c.name] = c
			go c.readloop()
		case str := <-s.msg:
			writeAll(str)
		case name := <-s.rem:
			dropConn(name)
		case <-s.stop:
			return
		}
	}
}

// A conn represents the server side of a single chat connection.
// Note we embed the bufio.Reader and net.Conn (and specifically in
// that order) so that a conn gets the appropriate methods from each
// to be a full io.ReadWriteCloser.
type conn struct {
	*bufio.Reader         // buffered input
	net.Conn              // raw connection
	server        *Server // the Server on which the connection arrived
	name          string
}

func newConn(s *Server, rwc net.Conn) *conn {
	return &conn{
		Reader: bufio.NewReader(rwc),
		Conn:   rwc,
		server: s,
	}
}

// welcome requests a name from the client before attempting to add the
// named connect to the set handled by the server.
func (c *conn) welcome() {
	var err error
	for c.name = ""; c.name == ""; {
		fmt.Fprint(c, "Enter your name: ")
		c.name, err = c.ReadString('\n')
		if err != nil {
			log.Printf("Reading name from %v: %v", c.RemoteAddr(), err)
			c.Close()
			return
		}
		c.name = strings.TrimSpace(c.name)
	}
	// The server will take this *conn and do a final check
	// on the name, possibly starting c.welcome() again.
	c.server.add <- c
}

// readloop is started as a go routine by the server once the initial
// welcome phase has completed successfully. It reads single lines from
// the client and passes them to the server for broadcast to all chat
// clients (including us).
// Once done, we ask the server to remove (and close) our connection.
func (c *conn) readloop() {
	for {
		msg, err := c.ReadString('\n')
		if err != nil {
			break
		}
		//msg = strings.TrimSpace(msg)
		c.server.msg <- c.name + "> " + msg
	}
	c.server.rem <- c.name
}
