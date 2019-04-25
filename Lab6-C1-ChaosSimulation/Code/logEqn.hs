-- play with a logistic equation

-- ----------BEGIN TYPES----------

-- ensure r<4
chkR :: Float -> Float
chkR n | n > 4 || n = 4 = error "r greater than or equal to 4"
       | otherwise = Float n

-- ensure 0<x<1
chkInitCond :: Float -> Float
chkInitCond n | n < 0 || n > 1 = error "x outside (0,1)"
              | otherwise = Float n

-- -----------END TYPES-----------

-- ----------BEGIN INPUT----------

-- get the command line arguments
-- [initial condition, coefficient, iterations]
getIn :: String -> [Float]
getIn s = map readFloat (words s)

-- read Strings as Floats
readFloat :: String -> Float
readFloat = read

-- -----------END INPUT-----------

-- ----------BEGIN LOGISTICS----------

logEq :: Float -> Float -> Int -> Float
logEq x r 0 = r * x * (1 - x)
logEq x r i = r * (logEq x r (i - 1)) * (1 - (logEq x r (i - 1)))

  
-- -----------END LOGISTICS-----------

-- ----------BEGIN OUTPUT----------



-- -----------END OUTPUT-----------

main :: IO()
main = interact $ output . getIn
