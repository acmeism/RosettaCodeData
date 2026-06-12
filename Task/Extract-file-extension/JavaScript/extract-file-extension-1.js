let filenames = ["http://example.com/download.tar.gz", "CharacterModel.3DS", ".desktop", "document", "document.txt_backup", "/etc/pam.d/login"];
let r = /\.[a-zA-Z0-9]+$/;
filenames.forEach((e) => console.log(e + " -> " + (r.test(e) ? r.exec(e)[0] : "")));
