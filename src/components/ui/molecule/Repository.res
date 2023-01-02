module View = {
  @react.component
  let make = (~repoInfo: Index_Fragment_graphql.Types.fragment_search_edges) => {
    let {node} = repoInfo

    let value = node->Option.flatMap(x => {
      switch x {
      | #Repository(fragment_search_edges_node_Repository) =>
        Some(fragment_search_edges_node_Repository)
      | #UnselectedUnionMember(_) => None
      }
    })

    <div>
      {switch value {
      | Some(value) =>
        <a className="block w-full py-2 cursor-pointer" target="_blank" rel="noopener noreferrer">
          <div className="space-y-2">
            <p className="font-bold"> {value.name->React.string} </p>
            {switch value.description {
            | Some(desc) => <p> {desc->React.string} </p>
            | None => React.null
            }}
            <StarCountUpdateButton
              id={value.id}
              viewerHasStarred={value.viewerHasStarred}
              stargazerCount={value.stargazerCount}
            />
          </div>
        </a>
      | None => <div> {"something went wrong"->React.string} </div>
      }}
    </div>
  }
}

@react.component
let make = (~repoInfo) => {
  <View repoInfo={repoInfo} />
}
