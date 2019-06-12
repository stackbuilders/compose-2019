let component = ReasonReact.statelessComponent("DisplayMessage");
let make = (~messages=[], ~className="alert alert-danger", _) => {
  ...component,
  render: _self =>
    <div className>
      {switch (messages) {
       | [] => ReasonReact.string("An error has occurred")
       | [message] => ReasonReact.string(message)
       | l =>
         <ul>
           {
List.map(key => <li key> {ReasonReact.string(key)} </li>, l)
            |> Array.of_list
            |> ReasonReact.array}
         </ul>
       }}
    </div>,
};
