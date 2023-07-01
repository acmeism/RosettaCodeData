env_var <- ifelse(.Platform$OS.type == "windows", "COMPUTERNAME", "HOSTNAME")
Sys.getenv(env_var)
