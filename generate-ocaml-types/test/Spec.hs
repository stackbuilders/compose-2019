import OCaml.Export
import Blog.OCaml.Package
import Test.Hspec

main :: IO ()
main = do
  mkGoldenFiles (Proxy :: Proxy BlogOCamlPackage) 100 "test/golden"
  hspec $ runGoldenSpec (Proxy :: Proxy BlogOCamlPackage) 100 "test/golden"
