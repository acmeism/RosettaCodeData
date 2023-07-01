url_encode()
{
        printf "%(url)q\n" "$*"
}


url_encode "http://foo bar/"
url_encode "https://ru.wikipedia.org/wiki/Транспайлер"
url_encode "google.com/search?q=`Abdu'l-Bahá"
