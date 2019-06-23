{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

module Main
    ( main
    )
where

import           Server                         ( app
                                                , newDB
                                                )
import           MockDB                         ( MockDB )

import           Test.Hspec
import           Test.Hspec.Wai
import           Control.Concurrent.STM.TVar    ( TVar )

main :: IO ()
main = do
  db <- newDB
  hspec $ spec db

spec :: TVar MockDB -> Spec
spec db = with (return $ app db) $ do
  describe "GET /articles" $
    it "responds with 200" $
      get "/articles" `shouldRespondWith` 200

  describe "GET /article" $
    context "when the article does not exist" $
      it "responds with 404" $
        get "/article/12" `shouldRespondWith` 404
