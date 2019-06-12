{-# LANGUAGE FlexibleContexts #-}

module Main where

import qualified Blog.OCaml.Package as Package
import           OCaml.Export

main :: IO ()
main = do
  mkPackageWithGolden
    (Proxy :: Proxy Package.BlogOCamlPackage)
    "test/golden"
    Package.fileMap
  where
    mkPackageWithGolden proxy dir fileMap = do
      let specOptions = SpecOptions "../blog-frontend/__tests__/Exported" dir Nothing
          packageOptions = PackageOptions "." "../blog-frontend/src/Exported" fileMap True (Just specOptions)
      mkGoldenFiles proxy 5 dir
      mkPackage proxy packageOptions
