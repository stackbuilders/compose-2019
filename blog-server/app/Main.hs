module Main where

import Server

main :: IO ()
main = do
  putStrLn $ "Server started on port " <> show port
  startApp
