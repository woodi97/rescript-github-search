@react.component
let make = (~overflowVisible=?, ~fullWidth=?, ~fixedHeight=?, ~children) => {
  <div
    className={cx([
      "relative w-full max-w-mobile-app m-center",
      overflowVisible->Option.getWithDefault(false) ? "overflow-visible" : "overflow-hidden",
    ])}>
    <Header fixed={true}>
      <div className="relative w-full flex justify-between items-center">
        <Next.Link href="/">
          <a>
            <h1 className="text-wy-blue-500 font-PyeongChangPeace-Bold">
              {"Search"->React.string}
            </h1>
          </a>
        </Next.Link>
      </div>
    </Header>
    <main
      className={cx([
        "relative m-center w-full pt-gb-header pb-bt-nav",
        fullWidth->Option.getWithDefault(false) ? "" : `max-w-mobile-app px-side-padding`,
        fixedHeight->Option.getWithDefault(false) ? "overflow-hidden h-screen" : "min-h-screen",
      ])}>
      {children}
    </main>
  </div>
}
