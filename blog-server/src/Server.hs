{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Server
    ( startApp
    , app
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
      :<|> "article" :> Capture "articleid" ArticleId :> Get '[JSON] (Maybe EntityArticle)

port :: Int
port = 8080

startApp :: IO ()
startApp = do
  tMockDB <- newTVarIO defaultMockDB
  run port $ app tMockDB

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
    getArticle aid = liftDB tMockDB >>= return . findEntity aid . articles
