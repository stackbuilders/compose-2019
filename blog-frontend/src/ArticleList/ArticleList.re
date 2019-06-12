open Types;

type state = loadable(list(entityArticle));

type action =
  | UpdateArticleList(list(entityArticle))
  | UpdateError(string)
  | DidMountUpdate;

let component = ReasonReact.reducerComponent("ArticleList");

let make = _children => {
  ...component,
  initialState: () => Loading,
  didMount: self => self.send(DidMountUpdate),
  reducer: (action, _) =>
    switch (action) {
    | DidMountUpdate =>
      ReasonReact.UpdateWithSideEffects(
        Loading,
        self =>
          Api.getArticles()
          |> Js.Promise.then_(result =>
               result
               |> Prelude.either(
                    message => UpdateError(message),
                    articles => UpdateArticleList(articles),
                  )
               |> self.send
               |> Js.Promise.resolve
             )
          |> ignore,
      )
    | UpdateArticleList(articleList) =>
      ReasonReact.Update(Loaded(articleList))
    | UpdateError(message) => ReasonReact.Update(Errored(message))
    },
  render: self =>
    switch (self.state) {
    | Loading => <LoadingIndicator />
    | Errored(message) => <DisplayMessage messages=[message] />
    | Loaded(articles) => <ArticlesTable articles />
    },
};
