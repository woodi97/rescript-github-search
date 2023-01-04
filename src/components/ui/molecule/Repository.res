@react.component
let make = (~repoInfo: Repositories_Fragment_graphql.Types.fragment_search_edges) => {
  let {node} = repoInfo

  <div>
    {switch node {
    | Some(node) =>
      switch node {
      | #Repository(value) =>
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
      | #UnselectedUnionMember(_) => React.null
      }
    | None => <div> {"Undefined Fragment"->React.string} </div>
    }}
  </div>
}
