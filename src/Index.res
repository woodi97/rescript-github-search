module Query = %relay(`
  query Index_Query($query: String!, $first: Int!, $after: String) {
    ...Index_Fragment @arguments(first: $first, after: $after)
  }
`)

module Fragment = %relay(`
  fragment Index_Fragment on Query
  @refetchable(queryName: "Index_Fragment_Query")
  @argumentDefinitions(first: { type: "Int!" }, after: { type: "String" }) {
    search(query: $query, type: REPOSITORY, first: $first, after: $after)
      @connection(key: "Index_Fragment_search") {
      __id
      edges {
        node {
          ... on Repository {
            id
            name
            description
            stargazerCount
            viewerHasStarred
            url
          }
        }
        cursor
      }
    }
  }
`)
module RepositoriesInfo = {
  @react.component
  let make = (~query) => {
    let {data: {search}, hasNext, loadNext} = query->Fragment.usePagination
    let {edges, __id} = search

    let loadMore = _ => {
      if hasNext {
        loadNext(~count=5, ())->ignore
      }
    }

    <div className="w-full max-w-4xl divide-y-2">
      {switch edges {
      | Some(edges) => <>
          {edges
          ->Array.map(edge => {
            switch edge {
            | Some(edge) => <Repository key={edge.cursor} repoInfo={edge} />
            | None => <div> {React.string("None")} </div>
            }
          })
          ->React.array}
        </>
      | None => <> {React.string("None")} </>
      }}
      {hasNext
        ? <Button onClick={_ => loadMore()}> {"click me"->React.string} </Button>
        : React.null}
    </div>
  }
}

module Container = {
  @react.component
  let make = () => {
    let timeoutRef = React.useRef(None)
    let (search, setSearch) = React.Uncurried.useState(_ => Env.defaultSearchText)
    let (query, setQuery) = React.Uncurried.useState(_ => Env.defaultSearchText)

    let {fragmentRefs} = Query.use(
      ~variables=Query.makeVariables(~query={query}, ~first=Env.defaultPagination, ()),
      (),
    )

    let handleOnChange = e => {
      let value = (e->ReactEvent.Synthetic.target)["value"]
      setSearch(._ => value)

      let _ = switch timeoutRef.current {
      | None => None
      | Some(ref) => {
          ref->Js.Global.clearTimeout
          None
        }
      }

      timeoutRef.current = Some(Js.Global.setTimeout(() => {
          setQuery(._ => value)
        }, 300))
    }
    <PageLayout>
      <div className="py-2">
        <Input name="search-box" fullWidth={true} value={search} onChange={handleOnChange} />
        <RepositoriesInfo query={fragmentRefs} />
      </div>
    </PageLayout>
  }
}

let default = () => {
  let fallback =
    <div className="fixed left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2">
      <Spinner width="60" height="60" />
    </div>

  <React.Suspense fallback={fallback}> <Container /> </React.Suspense>
}

// getServersideProps에서
// Query에 Fragment가 포함된 경우
// 결과값을 받아오지 못함(Serializable Object가 아니라서 불가능)
// 따라서 일단 CSR에서 Query를 실행하고
// Pagination을 위한 fragment Ref를 넘겨줌

// => FragmentRef 부분이 문제인 것 같다
// Fragment가 포함되지 않은 Query는 SSR에서 실행 가능

// let getServerSideProps = _ctx => {
//   Repositories.Query.fetchPromised(
//     ~environment=RelayEnv.environment,
//     ~variables={
//       login: "green-labs",
//       first: 5,
//       after: None,
//     },
//     (),
//   )->Js.Promise.then_(data => {
//     Js.log(data)
//     Js.Promise.resolve({"props": {"data": 1}})
//   }, _)
// }
