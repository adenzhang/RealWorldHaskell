-- file: ch24/ParMap.hs
import Control.Parallel (par)

parallelMap :: (a -> b) -> [a] -> [b]
parallelMap f (x:xs) = let r = f x
                       in r `par` r : parallelMap f xs
parallelMap _ _      = []

-- file: ch24/ParMap.hs
forceList :: [a] -> ()
forceList (x:xs) = x `pseq` forceList xs
forceList _      = ()

-- file: ch24/ParMap.hs
stricterMap :: (a -> b) -> [a] -> [b]
stricterMap f xs = forceList xs `seq` map f xs

-- file: ch24/ParMap.hs
forceListAndElts :: (a -> ()) -> [a] -> ()
forceListAndElts forceElt (x:xs) =
    forceElt x `seq` forceListAndElts forceElt xs
forceListAndElts _        _      = ()
