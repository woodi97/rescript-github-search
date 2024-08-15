module AddStarCount = %relay(`
  mutation StarCountUpdateButton_addStar_Mutation($input: AddStarInput!) {
    addStar(input: $input) {
      starrable {
        id
        stargazerCount
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
        stargazerCount
        viewerHasStarred
      }
    }
  }
`)

@react.component
let make = (~viewerHasStarred, ~stargazerCount, ~id) => {
  let (addStarMutate, isAddStarMutating) = AddStarCount.use()
  let (removeStarMutate, isRemoveStarMutating) = RemoveStarCount.use()

  let handleStarClick = (_, ~id, ~viewerHasStarred) => {
    if !isAddStarMutating && !isRemoveStarMutating {
      switch viewerHasStarred {
      | true =>
        removeStarMutate(
          ~variables={
            input: {
              starrableId: id,
              clientMutationId: None,
            },
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
          (),
        )->ignore
      }
    }
  }

  <Button
    type_="button"
    disabled={isAddStarMutating || isRemoveStarMutating}
    className={viewerHasStarred ? "bg-gray-200" : "bg-white"}
    size={Button.Small}
    onClick={handleStarClick(~id, ~viewerHasStarred)}>
    <span className="flex items-center space-x-2 pointer-events-none">
      <IconStar width="20" height="20" fill="yellow" />
      <p> {stargazerCount->Int.toString->React.string} </p>
    </span>
  </Button>
}
