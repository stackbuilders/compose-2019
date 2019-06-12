open BlogTypes;

type loadable('a) =
  | Loaded('a)
  | Errored(string)
  | Loading;

type entityArticle = entity(articleId, article);
