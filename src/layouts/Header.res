@react.component
let make = (~fixed=?, ~children) => {
  <header className="relative">
    <div
      className={cx([
        "z-20 w-full max-w-mobile-app h-gb-header top-0 bg-primary-bg",
        "px-side-padding py-2",
        "flex justify-between items-center align-middle",
        "font-bold",
        fixed->Option.getWithDefault(false) ? "fixed" : "absolute",
        "border-b-2 border-gray-200",
      ])}>
      {children}
    </div>
  </header>
}
