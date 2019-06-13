open Types;
open BlogTypes;

module Article =
  Page.MakePage({
    type t = entityArticle;
    type payload = string;

    let getData = payload =>
      switch (int_of_string(payload)) {
      | key => Api.getArticle(key)
      | exception _ =>
        Js.Promise.resolve(Belt.Result.Error("Id is not a number"))
      };

    let render = article =>
      [|
        <div className="row">
          <div className="col-md-12">
            <h2> {ReasonReact.string(article.entityValue.articleTitle)} </h2>
          </div>
        </div>,
        <div className="row">
          <div className="col-md-12">
            <i> {ReasonReact.string(article.entityValue.articleAuthor)} </i>
          </div>
        </div>,
        <div className="row">
          <div className="col-md-12">
            <blockquote className="blockquote">
              <p className="mb-0">
                {ReasonReact.string(article.entityValue.articleContent)}
              </p>
            </blockquote>
          </div>
        </div>,
        <div className="row">
          <div className="col-md-12">
            <i className="fas fa-chevron-left" />
            <a href="/#" className="btn btn-link">
              {ReasonReact.string("Back to reading list")}
            </a>
          </div>
        </div>,
      |]
      |> ReasonReact.array;
  });
