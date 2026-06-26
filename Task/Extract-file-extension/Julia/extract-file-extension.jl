extension(url::String) = try match(r"\.[A-Za-z0-9]+$", url).match catch; ""; end

@show extension("http://example.com/download.tar.gz")
@show extension("CharacterModel.3DS")
@show extension(".desktop")
@show extension("document")
@show extension("document.txt_backup")
@show extension("/etc/pam.d/login")
