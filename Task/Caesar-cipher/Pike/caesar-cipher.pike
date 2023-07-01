object c = Crypto.Substitution()->set_rot_key(2);
string msg     = "The quick brown fox jumped over the lazy dogs";
string msg_s2  = c->encrypt(msg);
c->set_rot_key(11);
string msg_s11 = c->encrypt(msg);
string decoded = c->decrypt(msg_s11);

write("%s\n%s\n%s\n%s\n", msg, msg_s2, msg_s11, decoded);
