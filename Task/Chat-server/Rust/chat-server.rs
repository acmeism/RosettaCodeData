use std::collections::HashMap;
use std::io;
use std::io::prelude::*;
use std::io::BufReader;
use std::net::{TcpListener, TcpStream};
use std::sync::{Arc, RwLock};
use std::thread;

type Username = String;

/// Sends a message to all clients except the sending client.
fn broadcast_message(
    user: &str,
    clients: &mut HashMap<String, TcpStream>,
    message: &str,
) -> io::Result<()> {
    for (client, stream) in clients.iter_mut() {
        if client != user {
            writeln!(stream, "{}", message)?;
        }
    }

    Ok(())
}

fn chat_loop(listener: &TcpListener) -> io::Result<()> {
    let local_clients: Arc<RwLock<HashMap<Username, TcpStream>>> =
        Arc::new(RwLock::new(HashMap::new()));

    println!("Accepting connections on {}", listener.local_addr()?.port());

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                let client_clients = Arc::clone(&local_clients);
                thread::spawn(move || -> io::Result<()> {
                    let mut reader = BufReader::new(stream.try_clone()?);
                    let mut writer = stream;

                    let mut name = String::new();
                    loop {
                        write!(writer, "Please enter a username: ")?;
                        reader.read_line(&mut name)?;
                        name = name.trim().to_owned();

                        let clients = client_clients.read().unwrap();
                        if !clients.contains_key(&name) {
                            writeln!(writer, "Welcome, {}!", &name)?;
                            break;
                        }

                        writeln!(writer, "That username is taken.")?;
                        name.clear();
                    }

                    {
                        let mut clients = client_clients.write().unwrap();
                        clients.insert(name.clone(), writer);
                        broadcast_message(
                            &name,
                            &mut *clients,
                            &format!("{} has joined the chat room.", &name),
                        )?;
                    }

                    for line in reader.lines() {
                        let mut clients = client_clients.write().unwrap();
                        broadcast_message(&name, &mut *clients, &format!("{}: {}", &name, line?))?;
                    }

                    {
                        let mut clients = client_clients.write().unwrap();
                        clients.remove(&name);
                        broadcast_message(
                            &name,
                            &mut *clients,
                            &format!("{} has left the chat room.", &name),
                        )?;
                    }

                    Ok(())
                });
            }
            Err(e) => {
                println!("Connection failed: {}", e);
            }
        }
    }

    Ok(())
}

fn main() {
    let listener = TcpListener::bind(("localhost", 7000)).unwrap();
    chat_loop(&listener).unwrap();
}
