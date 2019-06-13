open BlogTypes;

type loadable('a) =
  | Loaded('a)
  | Errored(string)
  | Loading;

type entityArticle = entity(articleId, article);

let unKey = (Key(k)) => k;

let string_of_articleId = (ArticleId(key)) => key->unKey->string_of_int;
