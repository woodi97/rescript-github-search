module Query = %relay(`
  query IndexQuery($owner: String!, $name: String!) {
    repository(owner: $owner, name: $name) {
      name
    }
  }
`)

type props = {data: IndexQuery_graphql.Types.response}

let default = props => {
  Js.log(props)
  <> <h1> {`getServerSideProps & Query.etchPromised`->React.string} </h1> </>
}

let getServerSideProps = _ctx => {
  Query.fetchPromised(
    ~environment=RelayEnv.environment,
    ~variables={
      owner: "facebook",
      name: "relay",
    },
    (),
  )->Js.Promise.then_(data => {
    Js.Promise.resolve({"props": {"data": data}})
  }, _)
}
