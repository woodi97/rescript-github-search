module Fragment = %relay(`
fragment RepositoryCard_Fragment on SearchResultItemEdge {
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
}
`)

@react.component
let make = (~query) => {
  let {node} = Fragment.use(query)

  <div>
    {switch node {
    | Some(node) =>
      <a className="block w-full py-2 cursor-pointer" target="_blank" rel="noopener noreferrer">
        <div className="space-y-2">
          <p className="font-bold"> {node.name->React.string} </p>
          {switch node.description {
          | Some(desc) => <p> {desc->React.string} </p>
          | None => React.null
          }}
          <StarCountUpdateButton
            id={node.id}
            viewerHasStarred={node.viewerHasStarred}
            stargazerCount={node.stargazerCount}
          />
        </div>
      </a>
    | None => <div> {"Undefined Fragment"->React.string} </div>
    }}
  </div>
}
