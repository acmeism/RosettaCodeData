use tokio::task::JoinSet;

#[tokio::main]
async fn main() {
    let words = vec!["Enjoy", "Rosetta", "Code"];
    let mut set = JoinSet::new();

    for word in words {
        set.spawn(async move {
            println!("{}", word);
        });
    }

    set.join_all().await;
}
