{- convert a space-delimited data file into a format friendly to the LaTeX
 - tabular environment -}

-- ----------BEGIN INPUT----------

-- convert initial string into lists of lines and words
getIn :: String -> [[String]]
getIn s = map words (lines s)

-- convert space-delimited string into list of strings
--line2List :: String -> [String]
--line2List s = map readStr (words s)

-- type-safe version of read for Strings
--readStr :: String -> String
--readStr = read

-- -----------END INPUT-----------

-- ----------BEGIN OUTPUT----------

-- output file with formatting applied
output :: [[String]] -> String
output [] = ""
output (l:ls) = showLine l ++ "\n" ++ output ls

-- apply formatting to a single line
showLine :: [String] -> String
showLine (w:[]) = show w ++ " \\\\"
showLine (w:ws) = show w ++ " & " ++ showLine ws

-- -----------END OUTPUT-----------

main :: IO()
main = interact $ output . getIn
