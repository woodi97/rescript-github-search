type env = {"NEXT_PUBLIC_API_ENDPOINT": string, "NEXT_PUBLIC_GITHUB_TOKEN": string}

@val external env: env = "process.env"

let apiEndPoint = env["NEXT_PUBLIC_API_ENDPOINT"]
let githubToken = env["NEXT_PUBLIC_GITHUB_TOKEN"]
let defaultPagination = 5
let defaultSearchText = "green_labs"
