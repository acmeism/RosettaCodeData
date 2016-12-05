// The following will return a list of all the cipher
// algorithms supported by the installation of Lasso
cipher_list

// With a -digest parameter the method will limit the returned list
// to all of the digest algorithms supported by the installation of Lasso
cipher_list(-digest)

// return the SHA-256 digest. Dependant on SHA-256 being an available digest method
cipher_digest('Rosetta Code', -digest='SHA-256',-hex=true)
