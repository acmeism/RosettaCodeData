PackageLoader fileInPackage: 'TCP'!

Object subclass: #HelloSocket
  instanceVariableNames: 'ss'
  classVariableNames: ''
  poolDictionaries: ''
  category: 'SimpleEcho'!

!HelloSocket class methodsFor: 'instance creation'!

port: anInteger
  | ses |
  ses := super new.
  ses init: anInteger.
  ^ses
!!

!HelloSocket methodsFor: 'instance initialization'!

init: anInteger
  ss := (TCP.ServerSocket port: anInteger).
  ^self
!!

!HelloSocket methodsFor: 'running'!

run
  | s |
  [
    ss waitForConnection.
    s := (ss accept).
    [self handleSocket: s] fork
  ] repeat
!!

!HelloSocket methodsFor: 'handling'!

handleSocket: s
    | msg |/**
 Sockets in Neko
 Tectonics:
   nekoc sockets.neko
   sudo nc -vulp 256 & sudo neko sockets
*/

var socket_init = $loader.loadprim("std@socket_init", 0);
var socket_new = $loader.loadprim("std@socket_new", 1);
var host_resolve = $loader.loadprim("std@host_resolve", 1);
var socket_connect = $loader.loadprim("std@socket_connect", 3);
var socket_write = $loader.loadprim("std@socket_write", 2);
var socket_close = $loader.loadprim("std@socket_close", 1);

/* Initialize Neko socket API */
socket_init();

/* true; UDP, false; TCP */
var socket = socket_new(true);

var c = socket_connect(socket, host_resolve("localhost"), 1256);
socket_write(socket, "hello socket world");

socket_close(socket);
    msg := 'hello socket world'.
    msg displayOn: s.
    (String with: (Character value: 10)) displayOn: s.
    s flush
!!

Smalltalk at: #helloServer put: (HelloSocket port: 2560).

helloServer run.
