import Data.ConfigFile
import Data.Either.Utils

getSetting cp x = forceEither $ get cp "Default" x

cp <- return . forceEither =<< readfile emptyCP "name_of_configuration_file"
let username = getSetting cp "username"
    password = getSetting cp "password"
