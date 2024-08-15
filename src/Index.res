module Query = %relay(`
  query Index_Query($query: String!, $first: Int!, $after: String) {
    ...RepositoriesView_Fragment @arguments(first: $first, after: $after)
  }
`)

module Container = {
  @react.component
  let make = (~searchText) => {
    let router = Next.Router.useRouter()

    let {fragmentRefs} = Query.use(
      ~variables=Query.makeVariables(~query=searchText, ~first=Env.defaultPagination, ()),
      (),
    )

    let handleSubmit = e => {
      e->ReactEvent.Synthetic.preventDefault
      let value = (e->ReactEvent.Synthetic.currentTarget)["elements"]["search"]["value"]
      router->Next.Router.push(`/?search=${value}`)
    }

    <PageLayout>
      <form onSubmit={handleSubmit}>
        <div className="flex">
          <Input type_="text" fullWidth={true} name="search" />
          <Button size={Button.Small} type_="submit"> {React.string("Search")} </Button>
        </div>
      </form>
      <RepositoriesView query={fragmentRefs} />
    </PageLayout>
  }
}

type props = {searchText: string}

let default = props => {
  <React.Suspense fallback={<Spinner position=Spinner.Center width="60" height="60" />}>
    <Container searchText={props.searchText} />
  </React.Suspense>
}

// 1. Form 기반 검색어 검색으로 바꾸기
// 2. Mutation시 initial state를 useState에 넣지 않고 기능 구현하기
// 3. preventDefault, stopPropagation 안쓰고 Update 버튼 만들기
// 4. getServerside 함수에 URL 기반 검색어 저장 기능 만들기

let getServerSideProps = (ctx: Next.GetServerSideProps.context<props, _, _>) => {
  let initialSearchInput = ctx.query->Js.Dict.get("search")->Option.getWithDefault("")
  Js.Promise.resolve({"props": {searchText: initialSearchInput}})
}
