use tokio::{sync::mpsc, task::JoinSet};

#[tokio::main]
async fn main() {
    let words = vec!["Enjoy", "Rosetta", "Code"];
    let mut set = JoinSet::new();

    let (tx, mut rx) = mpsc::channel(words.len());

    for word in words {
        let tx = tx.clone();
        set.spawn(async move {
            tx.send(word).await.unwrap();
        });
    }

    drop(tx);

    tokio::spawn(async move {
        set.join_all().await;
    });

    while let Some(word) = rx.recv().await {
        println!("{}", word);
    }
}
