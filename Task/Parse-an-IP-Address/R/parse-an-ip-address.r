# IP Address Parser in R
library(stringr)

# Helper function to convert decimal to 2-digit hex (for IPv4)
to_hex4 <- function(s) {
  val <- as.integer(s)
  if (is.na(val) || val < 0 || val > 255) {
    stop(paste("ERROR 101: Invalid value:", s))
  }
  sprintf("%02x", val)
}

# Helper function to validate and return hex value (for IPv6)
to_hex6 <- function(s) {
  val <- strtoi(s, base = 16)
  if (is.na(val) || val < 0 || val > 65535) {  # Fixed: should be 65535, not 65536
    stop(paste("ERROR 102: Invalid hex value:", s))
  }
  return(s)
}

# Helper function to count number of parts separated by colons
num_count <- function(s) {
  if (s == "") return(0)
  length(strsplit(s, ":")[[1]])
}

# Helper function to generate zero padding for IPv6 double colon expansion
get_zero <- function(count) {
  if (count <= 0) return("")
  paste0(":", paste(rep("0", count), collapse = ":"), ":")
}

# Main parsing function
parse_ip <- function(ip) {
  hex <- ""
  port <- ""

  # IPv4 pattern: xxx.xxx.xxx.xxx with optional :port
  ipv4_pattern <- "^(\\d+)\\.(\\d+)\\.(\\d+)\\.(\\d+)(?::(\\d+))?$"
  ipv4_match <- str_match(ip, ipv4_pattern)

  if (!is.na(ipv4_match[1])) {
    # Extract IPv4 components
    for (i in 2:5) {
      hex <- paste0(hex, to_hex4(ipv4_match[i]))
    }
    if (!is.na(ipv4_match[6])) {
      port <- ipv4_match[6]
    }
    return(c(hex, port))
  }

  # IPv6 with double colon pattern
  ipv6_double_colon_pattern <- "^\\[?([0-9a-f:]*)::([0-9a-f:]*)(?:\\]:(\\d+))?$"
  ipv6_dc_match <- str_match(tolower(ip), ipv6_double_colon_pattern)

  if (!is.na(ipv6_dc_match[1])) {
    p1 <- ipv6_dc_match[2]
    if (p1 == "") p1 <- "0"

    p2 <- ipv6_dc_match[3]
    if (p2 == "") p2 <- "0"

    # Expand the double colon
    zero_count <- 8 - num_count(p1) - num_count(p2)
    expanded_ip <- paste0(p1, get_zero(zero_count), p2)

    # Add port back if it exists
    if (!is.na(ipv6_dc_match[4])) {
      expanded_ip <- paste0("[", expanded_ip, "]:", ipv6_dc_match[4])
    }

    ip <- expanded_ip
  }

  # IPv6 full pattern (8 groups of hex digits)
  ipv6_pattern <- "^\\[?([0-9a-f]+):([0-9a-f]+):([0-9a-f]+):([0-9a-f]+):([0-9a-f]+):([0-9a-f]+):([0-9a-f]+):([0-9a-f]+)(?:\\]:(\\d+))?$"
  ipv6_match <- str_match(tolower(ip), ipv6_pattern)

  if (!is.na(ipv6_match[1])) {
    # Extract IPv6 components
    for (i in 2:9) {
      hex_part <- to_hex6(ipv6_match[i])
      # Pad to 4 characters
      hex <- paste0(hex, sprintf("%04s", hex_part))
    }
    hex <- str_replace_all(hex, " ", "0")

    if (!is.na(ipv6_match[10])) {
      port <- ipv6_match[10]
    }
    return(c(hex, port))
  }

  stop(paste("ERROR 103: Unknown address:", ip))
}

# Main execution
main <- function() {
  tests <- c(
    "192.168.0.1",
    "127.0.0.1",
    "256.0.0.1",
    "127.0.0.1:80",
    "::1",
    "[::1]:80",
    "[32e::12f]:80",
    "2605:2700:0:3::4713:93e3",
    "[2605:2700:0:3::4713:93e3]:80",
    "2001:db8:85a3:0:0:8a2e:370:7334"
  )

  cat(sprintf("%-40s %-32s   %s\n", "Test Case", "Hex Address", "Port"))

  for (ip in tests) {
    tryCatch({
      parsed <- parse_ip(ip)
      cat(sprintf("%-40s %-32s   %s\n", ip, parsed[1], parsed[2]))
    }, error = function(e) {
      cat(sprintf("%-40s Invalid address:  %s\n", ip, e$message))
    })
  }
}

# Run the main function
main()
