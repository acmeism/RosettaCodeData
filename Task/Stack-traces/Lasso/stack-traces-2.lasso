define stackexample => type {
    public oncreate => trace => { return self }
    public inner => trace => { }
    public middle => trace => { .inner }
    public outer => trace => { .middle }
}

stackexample->outer
