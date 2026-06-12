function extension($file){
    $ext = [System.IO.Path]::GetExtension($file)
    if (-not [String]::IsNullOrEmpty($ext)) {
        if($ext.IndexOf("_") -ne -1) {$ext = ""}
    }
    $ext
}
extension "http://example.com/download.tar.gz"
extension "CharacterModel.3DS"
extension ".desktop"
extension "document"
extension "document.txt_backup"
extension "/etc/pam.d/login"
