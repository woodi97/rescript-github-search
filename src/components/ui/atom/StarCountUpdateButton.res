module AddStarCount = %relay(`
  mutation StarCountUpdateButton_addStar_Mutation($input: AddStarInput!) {
    addStar(input: $input) {
      starrable {
        id
        viewerHasStarred
      }
    }
  }
`)

module RemoveStarCount = %relay(`
  mutation StarCountUpdateButton_removeStar_Mutation($input: RemoveStarInput!) {
    removeStar(input: $input) {
      starrable {
        id
        viewerHasStarred
      }
    }
  }
`)

@react.component
let make = (~viewerHasStarred, ~stargazerCount, ~id) => {
  let (starred, setStarred) = React.Uncurried.useState(_ => viewerHasStarred)
  let (count, setCount) = React.Uncurried.useState(_ => stargazerCount)

  let (addStarMutate, isAddStarMutating) = AddStarCount.use()
  let (removeStarMutate, isRemoveStarMutating) = RemoveStarCount.use()

  let handleStarClick = (~id, ~viewerHasStarred) => {
    if isAddStarMutating || isRemoveStarMutating {
      ()->ignore
    } else {
      switch viewerHasStarred {
      | true =>
        removeStarMutate(
          ~variables={
            input: {
              starrableId: id,
              clientMutationId: None,
            },
          },
          ~onCompleted=({removeStar}, _) => {
            switch removeStar {
            | Some(result) =>
              switch result.starrable {
              | Some(result) => {
                  setStarred(._ => result.viewerHasStarred)
                  setCount(.prev => prev - 1)
                }
              | None => ()
              }
            | None => ()
            }
          },
          (),
        )->ignore
      | false =>
        addStarMutate(
          ~variables={
            input: {
              starrableId: id,
              clientMutationId: None,
            },
          },
          ~onCompleted=({addStar}, _) => {
            switch addStar {
            | Some(result) =>
              switch result.starrable {
              | Some(result) => {
                  setStarred(._ => result.viewerHasStarred)
                  setCount(.prev => prev + 1)
                }
              | None => ()->ignore
              }
            | None => ()->ignore
            }
          },
          (),
        )->ignore
      }
    }
  }

  <Button
    className={starred ? "bg-green-400" : "bg-gray-300"}
    size={Button.Small}
    onClick={e => {
      e->ReactEvent.Synthetic.preventDefault
      e->ReactEvent.Synthetic.stopPropagation
      handleStarClick(~id, ~viewerHasStarred={starred})
    }}>
    <span className="flex items-center space-x-2 pointer-events-none">
      <IconStar width="20" height="20" fill="yellow" /> <p> {count->Int.toString->React.string} </p>
    </span>
  </Button>
}
