type env = {"NEXT_PUBLIC_API_ENDPOINT": string, "NEXT_PUBLIC_GITHUB_TOKEN": string}

@val external env: env = "process.env"

let apiEnvPoint = env["NEXT_PUBLIC_API_ENDPOINT"]
let githubToken = env["NEXT_PUBLIC_GITHUB_TOKEN"]
