{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Server
    ( startApp
    , port
    ) where

import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Control.Concurrent.STM.TVar (newTVarIO, readTVarIO, TVar)
import Control.Monad.IO.Class (liftIO)

import Blog.Types
import Entity.Find
import MockDB

type API = "articles" :> Get '[JSON] [EntityArticle]
      :<|> "article" :> Capture "articleid" ArticleId :> Get '[JSON] EntityArticle

port :: Int
port = 8080

startApp :: IO ()
startApp = run port . app =<< newTVarIO defaultMockDB

app :: TVar MockDB -> Application
app = serve api . server

api :: Proxy API
api = Proxy

liftDB :: TVar a -> Handler a
liftDB = liftIO . readTVarIO

server :: TVar MockDB -> Server API
server tMockDB = getArticleList :<|> getArticle
  where
    getArticleList = liftDB tMockDB >>= return . articles
    getArticle aid = liftDB tMockDB >>= foundOr404 . findEntity aid . articles

foundOr404 :: Maybe a -> Handler a
foundOr404 = maybe (throwError err404) return
