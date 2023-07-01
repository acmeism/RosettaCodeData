const net = require("net");
const EventEmitter = require("events").EventEmitter;

/*******************************************************************************
 * ChatServer
 *
 * Manages connections, users, and chat messages.
 ******************************************************************************/

class ChatServer {
    constructor() {
        this.chatters = {};
        this.server = net.createServer(this.handleConnection.bind(this));
        this.server.listen(1212, "localhost");
    }
    isNicknameLegal(nickname) {
        // A nickname may contain letters or numbers only,
        // and may only be used once.
        if (nickname.replace(/[A-Za-z0-9]*/, '') !== "") {
            return false;
        }
        for (const used_nick in this.chatters) {
            if (used_nick === nickname) {
                return false;
            }
        }
        return true;
    }
    handleConnection(connection) {
        console.log(`Incoming connection from ${connection.remoteAddress}`);
        connection.setEncoding("utf8");

        let chatter = new Chatter(connection, this);
        chatter.on("chat", this.handleChat.bind(this));
        chatter.on("join", this.handleJoin.bind(this));
        chatter.on("leave", this.handleLeave.bind(this));
    }
    handleChat(chatter, message) {
        this.sendToEveryChatterExcept(chatter, chatter.nickname + ": " + message);
    }
    handleJoin(chatter) {
        console.log(`${chatter.nickname} has joined the chat.`);
        this.sendToEveryChatter(`${chatter.nickname} has joined the chat.`);
        this.addChatter(chatter);
    }
    handleLeave(chatter) {
        console.log(`${chatter.nickname} has left the chat.`);
        this.removeChatter(chatter);
        this.sendToEveryChatter(`${chatter.nickname} has left the chat.`);
    }
    addChatter(chatter) {
        this.chatters[chatter.nickname] = chatter;
    }
    removeChatter(chatter) {
        delete this.chatters[chatter.nickname];
    }
    sendToEveryChatter(data) {
        for (const nickname in this.chatters) {
            this.chatters[nickname].send(data);
        }
    }
    sendToEveryChatterExcept(chatter, data) {
        for (const nickname in this.chatters) {
            if (nickname !== chatter.nickname) {
                this.chatters[nickname].send(data);
            }
        }
    }
}


/*******************************************************************************
 * Chatter
 *
 * Represents a single user/connection in the chat server.
 ******************************************************************************/

class Chatter extends EventEmitter {
    constructor(socket, server) {
        super();

        this.socket = socket;
        this.server = server;
        this.nickname = "";
        this.lineBuffer = new SocketLineBuffer(socket);

        this.lineBuffer.on("line", this.handleNickname.bind(this));
        this.socket.on("close", this.handleDisconnect.bind(this));

        this.send("Welcome! What is your nickname?");
    }
    handleNickname(nickname) {
        if (server.isNicknameLegal(nickname)) {
            this.nickname = nickname;
            this.lineBuffer.removeAllListeners("line");
            this.lineBuffer.on("line", this.handleChat.bind(this));
            this.send(`Welcome to the chat, ${nickname}!`);
            this.emit("join", this);
        } else {
            this.send("Sorry, but that nickname is not legal or is already in use!");
            this.send("What is your nickname?");
        }
    }
    handleChat(line) {
        this.emit("chat", this, line);
    }
    handleDisconnect() {
        this.emit("leave", this);
    }
    send(data) {
        this.socket.write(data + "\r\n");
    }
};


/*******************************************************************************
 * SocketLineBuffer
 *
 * Listens for and buffers incoming data on a socket and emits a 'line' event
 * whenever a complete line is detected.
 ******************************************************************************/

class SocketLineBuffer extends EventEmitter {
    constructor(socket) {
        super();

        this.socket = socket;
        this.buffer = "";

        this.socket.on("data", this.handleData.bind(this));
    }
    handleData(data) {
        for (let i = 0; i < data.length; i++) {
            const char = data.charAt(i);
            this.buffer += char;
            if (char == "\n") {
                this.buffer = this.buffer.replace("\r\n", "");
                this.buffer = this.buffer.replace("\n", "");
                this.emit("line", this.buffer);
                this.buffer = "";
            }
        }
    }
};


// Start the server!
server = new ChatServer();
