{-# LANGUAGE TemplateHaskell #-}

module Blog.OCaml.Package
  ( fileMap
  , BlogOCamlPackage
  ) where

import qualified Data.Map as M
import           Data.Map (Map)
import           Data.Proxy
import           Blog.OCaml.Types
import           OCaml.Export

fileMap :: Map String EmbeddedOCamlFiles
fileMap = M.fromList $(mkFiles True False (Proxy :: Proxy BlogOCamlPackage))
