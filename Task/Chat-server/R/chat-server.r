chat_loop <- function(server, sockets, delay = 0.5) {
    repeat {
        Sys.sleep(delay) # Saves CPU resources

        ## Exhausts queue each iteration
        while (in_queue(server))
            sockets <- new_socket_entry(server, sockets)

        ## Update which sockets have sent messages
        sockets <- check_messages(sockets)

        ## No sockets, nothing to do
        if (nrow(sockets) == 0)
            next

        ## No new messages, nothing to do
        if (all(!sockets$message_ready))
            next


        sockets <- read_messages(sockets) # Messages are stored until sent
        sockets <- drop_dead(sockets) # Dead = ready to read, but no data

        ## In case all sockets were dropped
        if (nrow(sockets) == 0)
            next

        sockets <- update_nicknames(sockets)
        sockets <- send_messages(sockets) # Only to users with nicknames
    }
}

check_messages <- function(sockets) {
    if (nrow(sockets) != 0)
        sockets$message_ready <- socketSelect(sockets$conn, timeout = 0)

    sockets
}

drop_dead <- function(sockets) {
    lapply(with(sockets, conn[!alive]), close)
    dropped <- with(sockets, nickname[nickname_exists(sockets) & !alive])
    sockets <- sockets[sockets$alive, ]

    if (length(dropped) != 0) {
        send_named(sockets, paste0(dropped, " has disconnected."))
    }

    sockets
}

in_queue <- function(server) socketSelect(list(server), timeout = 0)
is_valid_name <- function(nicks) gsub("[A-Za-z0-9]*", "", nicks) == ""
message_exists <- function(sockets) !is.na(sockets$message)

new_row <- function(df) {
    df[nrow(df) + 1, ] <- NA
    df
}

new_socket_entry <- function(server, sockets) {
    sockets <- new_row(sockets)
    n <- nrow(sockets)
    within(sockets, {
        conn[[n]] <- new_user(server)
        alive[n] <- TRUE
        message_ready[n] <- FALSE
    })
}

new_user <- function(server) {
    conn <- socketAccept(server)
    writeLines("Hello! Please enter a nickname.", conn)
    conn
}

nickname_exists <- function(sockets) !is.na(sockets$nickname)

read_messages <- function(sockets) {
    if (all(!sockets$message_ready))
        return(sockets)

    msgs <- lapply(with(sockets, conn[message_ready]), readLines, n = 1)
    empty_msgs <- sapply(msgs, identical, character(0))
    sockets <- within(sockets, alive[message_ready & empty_msgs] <- FALSE)
    msgs <- unlist(ifelse(empty_msgs, NA, msgs))
    within(sockets, message[message_ready] <- msgs)
}

send_messages <- function(sockets) {
    named_message <- message_exists(sockets) & nickname_exists(sockets)

    if (all(!named_message))
        return(sockets)

    rows <- which(named_message)
    socksub <- sockets[rows, ]
    time <- format(Sys.time(), "[%H:%M:%S] ")
    with(socksub, send_named(sockets, paste0(time, nickname, ": ", message)))
    within(sockets, message[rows] <- NA)
}

send_named <- function(sockets, msg) {
    has_nickname <- nickname_exists(sockets)
    invisible(lapply(sockets$conn[has_nickname], writeLines, text = msg))
}

start_chat_server <- function(port = 50525) {
    server <- serverSocket(port) # Start listening
    on.exit(closeAllConnections()) # Cleanup connections

    ## All socket data is stored and passed using this object
    sockets <- data.frame(conn = I(list()), nickname = character(),
                          message = character(), alive = logical(),
                          message_ready = logical())

    ## Main event loop
    chat_loop(server, sockets)
}

update_nicknames <- function(sockets) {
    sent_nickname <- message_exists(sockets) & !nickname_exists(sockets)
    nickname_valid <- is_valid_name(sockets$message)

    if (all(!sent_nickname))
        return(sockets)

    is_taken <- with(sockets, (tolower(message) %in% tolower(sockets$nickname)) &
                              !is.na(message))
    sent_ok <- sent_nickname & nickname_valid & !is_taken
    sockets <- within(sockets, {
        nickname[sent_ok] <- message[sent_ok]
        message[sent_nickname] <- NA
        lapply(conn[sent_nickname & !nickname_valid], writeLines,
               text = "Alphanumeric characters only. Try again.")
        lapply(conn[is_taken], writeLines,
               text = "Name already taken. Try again.")
    })

    if (any(sent_ok))
        send_named(sockets, paste0(sockets$nickname[sent_ok], " has connected."))

    sockets
}

start_chat_server()
