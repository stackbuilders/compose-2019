{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs              #-}
{-# LANGUAGE DeriveGeneric      #-}

module Blog.Types where

import Data.Aeson
import Data.Text
import Data.Typeable (Typeable)
import Web.HttpApiData
import GHC.Generics (Generic)

newtype Key = Key Int
  deriving (Eq, Ord, Generic)

instance ToJSON Key
instance FromJSON Key
instance FromHttpApiData Key where
  parseUrlPiece = fmap Key . parseUrlPiece

class IsKey a where
  fromKey :: Key -> a
  toKey   :: a -> Key

data Entity a b where
  Entity :: IsKey a =>
    { entityKey :: a
    , entityVal :: b
    } -> Entity a b

deriving instance (Typeable a, Typeable b) => Typeable (Entity a b)

instance (ToJSON a, ToJSON b) => ToJSON (Entity a b) where
  toJSON (Entity a b) = object
    [ "key"   .= a
    , "value" .= b
    ]

instance (IsKey a, FromJSON a, FromJSON b) => FromJSON (Entity a b) where
  parseJSON = withObject "Entity" $ \o ->
    Entity <$> o .: "key" <*> o .: "value"

newtype ArticleId = ArticleId Key
  deriving (Eq, Ord, Generic)

instance ToJSON ArticleId
instance FromJSON ArticleId

instance FromHttpApiData ArticleId where
  parseUrlPiece = fmap ArticleId . parseUrlPiece

instance IsKey ArticleId where
  fromKey key = ArticleId key
  toKey (ArticleId key) = key

data Article = Article
  { articleTitle   :: Text
  , articleAuthor  :: Text
  , articleContent :: Text
  }
  deriving (Eq, Ord, Generic)

instance ToJSON Article
instance FromJSON Article

type EntityArticle = Entity ArticleId Article

