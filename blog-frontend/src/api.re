let mkUrl = endpoint => {
  let baseURL = "http://localhost:8080";
  baseURL ++ endpoint;
};

let unexpectedResponse = response =>
  Fetch.Response.text(response)
  |> Js.Promise.(then_(text =>
       Belt.Result.Error(text === "" ? "Unexpected error" : text) |> resolve
     ));

let makeGetRequest = () =>
  Fetch.RequestInit.make(
    ~method_=Bs_fetch.Get,
    ~credentials=Include,
    ~headers=
      Fetch.HeadersInit.makeWithArray([|
        ("Accept", "application/json"),
        ("Content-Type", "application/json"),
      |]),
    (),
  );

let decodeArticleEntityList =
  Aeson.Decode.(
    wrapResult(
      list(a =>
        unwrapResult(
          BlogTypes.(decodeEntity(decodeArticleId, decodeArticle, a)),
        )
      ),
    )
  );

let getArticles:
  unit => Js.Promise.t(Belt.Result.t(list(Types.entityArticle), string)) =
  () =>
    makeGetRequest()
    |> Fetch.fetchWithInit(mkUrl("/articles"))
    |> Js.Promise.(
         then_(response =>
           switch (Fetch.Response.status(response)) {
           | 200 =>
             Fetch.Response.json(response)
             |> then_(json => decodeArticleEntityList(json) |> resolve)
           | _ => unexpectedResponse(response)
           }
         )
       )
    |> Js.Promise.catch(_ =>
         Belt.Result.Error("An error occured while fetching the Article List")
         |> Js.Promise.resolve
       );

let getArticle:
  int => Js.Promise.t(Belt.Result.t(Types.entityArticle, string)) =
  key =>
    makeGetRequest()
    |> Fetch.fetchWithInit(mkUrl({j|/article/$key|j}))
    |> Js.Promise.(
         then_(response =>
           switch (Fetch.Response.status(response)) {
           | 404 => Belt.Result.Error({j|Article $key not found|j}) |> resolve
           | 200 =>
             Fetch.Response.json(response)
             |> then_(json =>
                  BlogTypes.(
                    decodeEntity(decodeArticleId, decodeArticle, json)
                  )
                  |> resolve
                )
           | _ => unexpectedResponse(response)
           }
         )
       )
    |> Js.Promise.catch(_ =>
         Belt.Result.Error({j|An error occured while fetching Article $key|j})
         |> Js.Promise.resolve
       );
