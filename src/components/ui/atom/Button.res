type buttonType = Button | Submit | Reset
type buttonRoundness = Rounded | Primary | Square
type buttonSize = Small | Medium | Large
type buttonStyle = Primary | Secondary | Tertiary | Danger | Success | Warning

type field = {
  type_: option<buttonType>,
  size: option<buttonSize>,
  styles: option<buttonStyle>,
  roundness: option<buttonRoundness>,
  disabled: option<bool>,
  fullWidth: option<bool>,
  className: option<string>,
  children: React.element,
  onClick: option<unit => unit>,
}

let selectType = type_ => {
  switch type_ {
  | Button => "button"
  | Submit => "submit"
  | Reset => "reset"
  }
}

let selectRoundness = roundness => {
  switch roundness {
  | Rounded => "rounded-full"
  | Primary => "rounded-md"
  | Square => "rounded-none"
  }
}

let selectSize = size => {
  switch size {
  | Small => "px-4 py-2 text-sm"
  | Medium => "px-8 py-4 text-base"
  | Large => "px-12 py-4 text-lg"
  }
}

let selectStyle = style => {
  switch style {
  | Primary => "bg-primary-500 focus:bg-primary-900"
  | Secondary => "bg-secondary-500 focus:bg-secondary-900"
  | Tertiary => "bg-slate-100 focus:bg-slate-200"
  | Danger => "bg-red-700 text-red-100 focus:bg-red-600"
  | Success => "bg-green-700 text-green-100 focus:bg-green-600"
  | Warning => "bg-orange-700 text-orange-100 focus:bg-orange-600"
  }
}

@react.component
let make = (
  ~type_=?,
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
    type_={selectType(type_->Option.getWithDefault(Button))}
    className={cx([
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
