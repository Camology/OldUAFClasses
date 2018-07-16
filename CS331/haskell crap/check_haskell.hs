-- check_haskell.hs
-- Glenn G. Chappell
-- 2 Feb 2018
--
-- For CS F331 / CSCE A331 Spring 2018
-- A Haskell Program to Run
-- Used in Assignment 2, Exercise A

module Main where


-- main
-- Print second secret message.
main = do
    putStrLn "Secret message #2:"
    putStrLn ""
    putStrLn secret_message


-- secret_message
-- A mysterious message.
secret_message = map xk xj where
    xa = [80,-34,79,0,28,-10,-62,72,-58,74,5,26,-77,94,-8,14]
    xb = [-72,74,5,20,7,8,12,-77,84,-1,17,15,-66,-7,57,26]
    xc = [3,18,7,20,-68,-7,15,41,50,5,8,-77,91,-5,14,13]
    xd = [-7,8,19,-77,96,-3,13,-78,86,13,-7,8,19,-77,91,2]
    xe = [-72,82,10,8,15,-80,91,-5,0,26,-63,2]
    xf = [11]
    xg = "The treasure is buried under a palm tree on the third island."
    xh = map (+ xl) $ concat [xa, xb, xc, xd, xe]
    xi a as = a : map (+ a) as
    xj = foldr xi [] xh
    xk a = toEnum a `asTypeOf` (head xg)
    xl = foldr (!!) (head xf) [xb, xc, xb]

