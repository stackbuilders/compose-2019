{-# LANGUAGE OverloadedStrings  #-}

module MockDB
  ( MockDB(..)
  , defaultMockDB
  ) where

import Blog.Types

data MockDB = MockDB
  { articles :: [EntityArticle]
  }

articleList :: [Article]
articleList =
  [ Article
    { articleTitle    = "Matrix 1.0 and the Matrix.org Foundation"
    , articleAuthor   = "matrix.org"
    , articleContent  = "Lorem ipsum dolor"
    }
  , Article
    { articleTitle    = "C++ Patterns: The Badge"
    , articleAuthor   = "awesomekling.github.io"
    , articleContent  = "Lorem ipsum dolor"
    }
  , Article
    { articleTitle    = "The Day the Music Burned"
    , articleAuthor   = "nytimes.com"
    , articleContent  = "Lorem ipsum dolor"
    }
  ]

defaultMockDB :: MockDB
defaultMockDB = MockDB
  { articles = fmap (uncurry mkEntityArticle) $ zip [1..] articleList
  }
  where
    mkEntityArticle key article = Entity (ArticleId $ Key key) article

