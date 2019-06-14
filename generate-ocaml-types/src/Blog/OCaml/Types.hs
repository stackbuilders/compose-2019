{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE FlexibleInstances    #-}

module Blog.OCaml.Types where

import           OCaml.Export
import           Test.QuickCheck
import           Test.QuickCheck.Arbitrary.ADT
import           Blog.Types
import           Data.Text                      ( Text )
import qualified Data.Text                     as T
import           Numeric.Natural                ( Natural )

type BlogOCamlPackage
  = OCamlPackage
    "blog-types"
    '[]
    :>
    ( OCamlModule
        '["BlogTypes"]
        :>
        Key
        :>
        ArticleId
        :>
        Article
        :>
        OCamlTypeInFile
        (Entity TypeParameterRef0 TypeParameterRef1)
        "ocaml/Entity"
    )

-- Text orphan instance
instance Arbitrary Text where
  arbitrary = T.pack <$> listOf (elements [' ' .. 'z'])

-- Natural orphan instance
instance Arbitrary Natural where
  arbitrary = fromIntegral <$> (arbitrary :: Gen Int) `suchThat` (>= 0)

instance Arbitrary Key where
  arbitrary = Key <$> arbitrary
instance ToADTArbitrary Key
instance OCamlType Key

instance Arbitrary ArticleId where
  arbitrary = ArticleId <$> arbitrary
instance ToADTArbitrary ArticleId
instance OCamlType ArticleId

instance Arbitrary Article where
  arbitrary = Article <$> arbitrary <*> arbitrary <*> arbitrary
instance ToADTArbitrary Article
instance OCamlType Article

-- we need this instance because of the restrictions on Entity
instance IsKey TypeParameterRef0 where
  fromKey (Key k) = TypeParameterRef0 $ fromIntegral k
  toKey (TypeParameterRef0 k) = Key $ fromIntegral k

instance (IsKey a, Arbitrary a, Arbitrary b) => Arbitrary (Entity a b) where
  arbitrary = Entity <$> arbitrary <*> arbitrary

instance (IsKey a, Arbitrary a, ToADTArbitrary a, Arbitrary b, ToADTArbitrary b) =>
  ToADTArbitrary (Entity a b) where
  toADTArbitrarySingleton Proxy = ADTArbitrarySingleton "Blog.Types" "Entity"
    <$> oneof [ConstructorArbitraryPair "Entity" <$> arbitrary]

  toADTArbitrary Proxy = ADTArbitrary "Blog.Types" "Entity"
    <$> sequence [ConstructorArbitraryPair "Entity" <$> arbitrary]

instance OCamlType (Entity TypeParameterRef0 TypeParameterRef1) where
  toOCamlType _ = typeableToOCamlType
    (Proxy :: Proxy (Entity TypeParameterRef0 TypeParameterRef1))
