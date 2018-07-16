-- PA5.hs  
-- Cameron K Titus
-- 27 March 2018
--
--Jacob, if you can read this hello ! 

module PA5 where
import Data.List

-- collatzCounts, infinte list computes only as needed
collatzCounts = map collatzList [1..]

--List for collatz
collatzList input 
    | input == 1 = 0
    | collatzFunc input == 1 = 1
    | otherwise = 1 + collatzList (collatzFunc input)

--Actual collatz function    
collatzFunc input 
    | input == 0 = 0
    | mod input 2 == 0 = div input 2
    | otherwise = 3*input+1

-- findList. returns if l1 is a sublist of l2, if so returns the index
findList :: Eq a => [a] -> [a] -> Maybe Int
findList l1 l2 = findIndex (isPrefixOf l1) (tails l2)


-- comp function, given a list of lists it will return the number of times
-- the two lists are equal at the same exact places 
comp :: Eq a => [[a]] -> Integer
comp l
    | length l == 0 = 0
    | length (head l) <= 1 = 0
    | head (head l) == last (head l) = 1 + comp (tail l)
    | otherwise = comp (tail l)

-- ## operator, transforms into a list of lists and calls comp which compares
-- and returns the indexes of the locations they are equal at    
l1 ## l2 = num where 
  num = comp (transpose [l1, l2])

--given a tuple, retrieve the first or second element
getTuple1 (first,_) = first
getTuple2 (_,second) = second

-- filterAB , takes a boolean value and 2 lists, and returns the values that match
-- true for the given boolean function.
filterAB fn l1 l2 = anslist where
    pairList = zip l1 l2 
    truL = filter (fn.fst) pairList
    anslist = getTuple2 (unzip truL) 


--tupleList: generate a tuple from a list
tupleList [] = ([], [])
tupleList [x] = ([x],[])
tupleList (x:y:xs) = (x:xp, y:yp ) where (xp, yp) = tupleList xs    

-- sumEvenOdd return a tuple where fist is a sum of all even index and second is a sum of
-- all odd indexes
sumEvenOdd list = tuple where 
    tuplePieces = tupleList list
    evens = foldr (+) 0 (getTuple1 tuplePieces)
    odds = foldr (+) 0 (getTuple2 tuplePieces)
    tuple = (evens, odds)

