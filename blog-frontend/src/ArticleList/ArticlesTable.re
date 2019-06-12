open BlogTypes;

let component = ReasonReact.statelessComponent("ArticlesTable");

let style = ReactDOMRe.Style.make(~margin="2em", ());

let make = (~articles, _children) => {
  ...component,
  render: _self =>
    [|
      <div className="row" key="title" style>
        <div className="col-md-12">
          <h2> {ReasonReact.string("ReasonML Blog -- Article List")} </h2>
        </div>
      </div>,
      <div className="row" key="table">
        {articles
         |> List.map(article =>
              <ArticleRow article key={article.entityKey |> string_of_int} />
            )
         |> Array.of_list
         |> ReasonReact.array}
      </div>,
    |]
    |> ReasonReact.array,
};
