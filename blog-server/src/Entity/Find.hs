module Entity.Find where

import Data.List
import Blog.Types

findEntity :: (IsKey a, Eq a) => a -> [Entity a b] -> Maybe (Entity a b)
findEntity key = find (\(Entity key' _) -> key == key')
