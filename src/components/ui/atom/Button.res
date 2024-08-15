type buttonType = Button | Submit | Reset
type buttonRoundness = Rounded | Primary | Square
type buttonSize = Small | Medium | Large
type buttonStyle = Primary | Secondary | Tertiary | Danger | Success | Warning

let selectRoundness = roundness => {
  switch roundness {
  | Rounded => "rounded-full"
  | Primary => "rounded-md"
  | Square => "rounded-none"
  }
}

let selectSize = size => {
  switch size {
  | Small => "px-2 py-1 text-sm"
  | Medium => "px-4 py-2 text-base"
  | Large => "px-6 py-2 text-lg"
  }
}

let selectStyle = style => {
  switch style {
  | Primary => "bg-gray-200"
  | Secondary => "bg-secondary-500"
  | Tertiary => "bg-slate-100"
  | Danger => "bg-red-700 text-red-100"
  | Success => "bg-green-700 text-green-100"
  | Warning => "bg-orange-700 text-orange-100"
  }
}

@react.component
let make = (
  ~type_,
  ~size=?,
  ~styles=?,
  ~roundness=?,
  ~disabled=?,
  ~fullWidth=?,
  ~className=?,
  ~children,
  ~onClick=?,
) => {
  <button
    type_
    className={cx([
      "border-[1px] border-gray-100",
      className->Option.getWithDefault(""),
      fullWidth->Option.getWithDefault(false) ? "w-full" : "",
      selectSize(size->Option.getWithDefault(Medium)),
      selectStyle(styles->Option.getWithDefault((Primary: buttonStyle))),
      selectRoundness(roundness->Option.getWithDefault((Primary: buttonRoundness))),
    ])}
    ?disabled
    ?onClick>
    {children}
  </button>
}
