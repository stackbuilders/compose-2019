{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeOperators     #-}
{-# LANGUAGE OverloadedStrings #-}

module Server
    ( startApp
    , port
    ) where

import Network.Wai.Middleware.Cors ( cors, simpleCorsResourcePolicy
                                   , corsRequestHeaders
                                   , corsOrigins
                                   , corsMethods
                                   )
import Network.HTTP.Types.Method   (renderStdMethod)
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

withCors :: Middleware
withCors =
  let allowedOrigins = [ "http://127.0.0.1:3000"
                       , "http://localhost:3000"
                       ]
      allowedHeaders = [ "content-type"
                       , "dnt"
                       , "cache-control"
                       , "expires"
                       , "pragma"
                       ]
  in cors $ const $ Just simpleCorsResourcePolicy
    { corsRequestHeaders = allowedHeaders
    , corsOrigins        = Just (allowedOrigins, True)
    -- allow all methods
    , corsMethods        = fmap renderStdMethod [minBound..maxBound]
    }

startApp :: IO ()
startApp = run port . withCors . app =<< newTVarIO defaultMockDB

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
