open BlogTypes;

let mkLink = id => {j|#/article/$id|j};

let component = ReasonReact.statelessComponent("ArticleRow");

let style = ReactDOMRe.Style.make(~width="18rem", ~margin="1em", ());
let linkStyle =
  ReactDOMRe.Style.make(
    ~position="absolute",
    ~bottom="0",
    ~marginBottom="0.1em",
    (),
  );

let make = (~article, _children) => {
  ...component,
  render: _self =>
    <div className="card" style>
      <div className="card-body">
        <h5 className="card-title">
          {ReasonReact.string(article.entityValue.articleTitle)}
        </h5>
        <p className="card-text">
          {ReasonReact.string(article.entityValue.articleAuthor)}
        </p>
        <div style=linkStyle>
          <a href={mkLink(article.entityKey)} className="btn btn-link">
            {ReasonReact.string("Read Article")}
          </a>
        </div>
      </div>
    </div>,
};
