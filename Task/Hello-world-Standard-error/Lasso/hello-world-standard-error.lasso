define stderr(s::string) => {
    file_stderr->writeBytes(#s->asBytes)
}

stderr('Goodbye, World!')
