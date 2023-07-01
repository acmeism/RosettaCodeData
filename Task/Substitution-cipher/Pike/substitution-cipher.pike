string alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
string key      = "VsciBjedgrzyHalvXZKtUPumGfIwJxqOCFRApnDhQWobLkESYMTN";
mapping key_mapping = mkmapping(alphabet/1, key/1);
object c = Crypto.Substitution()->set_key(key_mapping);

string msg = "The quick brown fox jumped over the lazy dogs";
string msg_enc = c->encrypt(msg);
string msg_dec = c->decrypt(msg_enc);

write("Encrypted: %s\n", msg_enc);
write("Decrypted: %s\n", msg_dec);
