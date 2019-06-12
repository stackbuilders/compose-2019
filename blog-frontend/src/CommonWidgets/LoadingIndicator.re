let component = ReasonReact.statelessComponent("LoadingIndicator");

let make =
    (
      ~color="#1d0e0b",
      ~position="absolute",
      ~location="50%",
      ~loadingText="Loading . . . ",
      _children,
    ) => {
  ...component,
  render: _self =>
    <div
      style=(ReactDOMRe.Style.make(~position, ~left=location, ~top=location, ()))>
      <LoadingCircle color />
      <span
        style=(
          ReactDOMRe.Style.make(
            ~display="inline-block",
            ~marginLeft="5px",
            ~verticalAlign="middle",
            ~paddingBottom="10px",
            (),
          )
        )>
        (ReasonReact.string(loadingText))
      </span>
    </div>,
};
