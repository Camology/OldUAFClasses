--Cameron K. Titus
--Median.hs for PA5 
--CS331 UAF Spring 2018

--haskell program that takes input from a user and once finished will find the median value

import System.IO    
import Data.List 
import Data.Char 


main = do 
    putStrLn "Please enter a list of numbers, I will find the median value for you"
    answer <- median 
    hFlush stdout
    if (answer == 9999999999) then
        putStrLn "Empty list, not a good idea!"
    else do
        putStrLn "Now close your eyes, I will make the median appear in..."
        putStrLn "...3..."
        putStrLn "...2..."
        putStrLn "...1..."
        putStr "The median is >>> "
        print (answer)
    hFlush stdout
    
    putStrLn "Wanna try again? [Y/N]"
    restart <- getLine
    if map toLower restart == "y" then
        main
    else do 
        putStrLn "Goodbye! This computer loves to do numbers for you!"


numbers = do 
    putStrLn "Enter a number for a good time! Blank when you are done!"
    input <- getLine 
    if input == "" then
        return []
    else do
        let num = read input ::Int
        next <- numbers
        return (num: next)

median = do 
    nums <- numbers
    if length nums == 0
        then return 9999999999
    else do
        sorted <- superSort (nums)
        lengthy <- listLength (sorted)
        middle <- middle (lengthy)
        return (sorted !! middle)

superSort list = do 
    return (sort list)

listLength list = do 
    return (length list)

middle len = do 
    return (div len 2)