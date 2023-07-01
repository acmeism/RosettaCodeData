isExt filename = any (`elem` (tails . toLower $ filename)) . map toLower
