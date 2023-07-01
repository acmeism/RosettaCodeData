int main(){
    mapping(string:string) coll = (["foo":"asdf", "bar":"qwer", "quux":"zxcv"]);
    foreach (coll;string key;string val)
        write(key+" --> "+val+"\n");
    }
}
