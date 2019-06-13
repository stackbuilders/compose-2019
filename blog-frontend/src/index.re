[%bs.raw {|require('./index.css')|}];

[@bs.module "./serviceWorker"]
external register_service_worker: unit => unit = "register";
[@bs.module "./serviceWorker"]
external unregister_service_worker: unit => unit = "unregister";

let renderForRoute = component =>
  ReactDOMRe.renderToElementWithId(component, "root");

let router =
  DirectorRe.makeRouter({
    "/": payload => <ArticleList.ArticleList payload /> |> renderForRoute,
    "/article/:articleId": payload =>
      <Article.Article payload key=payload /> |> renderForRoute,
  });

DirectorRe.init(router, "/");

unregister_service_worker();
