type inputSize = Small | Medium | Large

let selectSize = size => {
  switch size {
  | Small => "w-40 h-8 text-sm"
  | Medium => "w-60 h-12 text-base"
  | Large => "w-80 h-16 text-lg"
  }
}

@react.component
let make = (~className=?, ~fullWidth=?, ~size=?, ~disabled=?, ~value=?, ~onChange=?, ~name) => {
  <div
    className={cx([
      className->Option.getWithDefault(""),
      fullWidth->Option.getWithDefault(false)
        ? "w-full"
        : selectSize(size->Option.getWithDefault(Medium)),
      "border-2 rounded-xl",
      "overflow-hidden",
      "focus-within:border-blue-500",
    ])}>
    <label htmlFor={name} />
    <input
      className={"p-2 w-full h-full no-border-outline"}
      id={name}
      name={name}
      ?disabled
      ?value
      ?onChange
    />
  </div>
}
