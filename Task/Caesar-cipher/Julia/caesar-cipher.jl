# Caeser cipher
# Julia 1.5.4
# author: manuelcaeiro | https://github.com/manuelcaeiro

function csrcipher(text, key)
    ciphtext = ""
    for l in text
        numl = Int(l)
        ciphnuml = numl + key
        if numl in 65:90
            if ciphnuml > 90
                rotciphnuml = ciphnuml - 26
                ciphtext = ciphtext * Char(rotciphnuml)
            else
                ciphtext = ciphtext * Char(ciphnuml)
            end
        elseif numl in 97:122
            if ciphnuml > 122
                rotciphnuml = ciphnuml - 26
                ciphtext = ciphtext * Char(rotciphnuml)
            else
                ciphtext = ciphtext * Char(ciphnuml)
            end
        else
            ciphtext = ciphtext * Char(numl)
        end
    end
    return ciphtext
end

text = "Magic Encryption"; key = 13
csrcipher(text, key)
