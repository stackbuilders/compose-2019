let mkUrl = endpoint => {
  let baseURL = "http://localhost:8080";
  baseURL ++ endpoint;
};

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
             |> then_(json =>
                  Aeson.Decode.(
                    json
                    |> wrapResult(
                         list(a =>
                           unwrapResult(
                             BlogTypes.(
                               decodeEntity(decodeArticleId, decodeArticle, a)
                             ),
                           )
                         ),
                       )
                  )
                  |> resolve
                )
           | _ =>
             Fetch.Response.text(response)
             |> then_(text =>
                  resolve(
                    Belt.Result.Error(
                      text === "" ? "Unexpected error" : text,
                    ),
                  )
                )
           }
         )
       )
    |> Js.Promise.catch(_ =>
         Js.Promise.resolve(
           Belt.Result.Error(
             "An error occured while fetching the Article List",
           ),
         )
       );
