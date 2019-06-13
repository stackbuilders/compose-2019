open Types;

module ArticleList =
  Page.MakePage({
    type t = list(entityArticle);
    type payload = unit;
    let getData = Api.getArticles;
    let render = articles => <ArticlesTable articles />;
  });
