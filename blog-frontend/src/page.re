open Types;

module type PageConfig = {
  type t;
  type payload;
  let getData: payload => Js.Promise.t(Belt.Result.t(t, string));
  let render: t => ReasonReact.reactElement;
};

module MakePage = (Config: PageConfig) => {
  type state = loadable(Config.t);

  type action =
    | UpdateSuccess(Config.t)
    | UpdateError(string)
    | DidMountUpdate;

  let component = ReasonReact.reducerComponent("Page");

  let make = (~payload: Config.payload, _children) => {
    ...component,
    initialState: () => Loading,
    didMount: self => self.send(DidMountUpdate),
    reducer: (action, _) =>
      switch (action) {
      | DidMountUpdate =>
        ReasonReact.UpdateWithSideEffects(
          Loading,
          self =>
            Config.getData(payload)
            |> Js.Promise.then_(result =>
                 result
                 |> Prelude.either(
                      message => UpdateError(message),
                      data => UpdateSuccess(data),
                    )
                 |> self.send
                 |> Js.Promise.resolve
               )
            |> ignore,
        )
      | UpdateSuccess(data) => ReasonReact.Update(Loaded(data))
      | UpdateError(message) => ReasonReact.Update(Errored(message))
      },
    render: self =>
      switch (self.state) {
      | Loading => <LoadingIndicator />
      | Errored(message) => <DisplayMessage messages=[message] />
      | Loaded(data) => Config.render(data)
      },
  };
};
