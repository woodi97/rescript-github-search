// 숙제: fragment를 컴포넌트 단위로 좀 더 나눠보기

module Fragment = %relay(`
  fragment Repositories_Fragment on Query
  @refetchable(queryName: "Refetch_Repositories_Fragment_Query")
  @argumentDefinitions(first: { type: "Int!" }, after: { type: "String" }) {
    search(query: $query, type: REPOSITORY, first: $first, after: $after)
      @connection(key: "Index_Fragment_search") {
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

@react.component
let make = (~query) => {
  let {data: {search: {edges}}, hasNext, loadNext} = query->Fragment.usePagination

  let loadMore = _ => {
    if hasNext {
      loadNext(~count=5, ())->ignore
    }
  }

  <div className="w-full max-w-5xl divide-y-2">
    {switch edges {
    | Some(edges) =>
      switch edges {
      | [] => <> {React.string("Repository Not found")} </>
      | _ => <>
          {edges
          ->Array.map(edge => {
            switch edge {
            | Some(edge) => <Repository key={edge.cursor} repoInfo={edge} />
            | None => <div> {React.string("Repository Not found")} </div>
            }
          })
          ->React.array}
        </>
      }

    | None => <> {React.string("Repository Not found")} </>
    }}
    {hasNext
      ? <Button type_="button" onClick={_ => loadMore()}> {"click me"->React.string} </Button>
      : React.null}
  </div>
}
