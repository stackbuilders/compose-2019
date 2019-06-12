let component = ReasonReact.statelessComponent("LoadingCircle");

let make = (~color="#1d0e0b", _children) => {
  ...component,
  render: _self =>
    <svg
      width="18px"
      height="18px"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 100 100"
      preserveAspectRatio="xMidYMid">
      <circle
        cx="50"
        cy="50"
        fill="none"
        stroke=color
        strokeWidth="10"
        r="35"
        strokeDasharray="164.93361431346415 56.97787143782138"
        transform="rotate(316.667 50 50)">
        <animateTransform
          attributeName="transform"
          calcMode="linear"
          type_="rotate"
          values="0 50 50;360 50 50"
          keyTimes="0;1"
          dur="1.8s"
          begin_="0s"
          repeatCount="indefinite"
        />
      </circle>
    </svg>,
};
