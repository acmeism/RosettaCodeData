isExt filename extensions = any (`elem` allTails) lowerExtensions
                            where allTails = tails . toLower $ filename
			          lowerExtensions = map toLower extensions
