using Documenter
using SeaweedFSClient
using Dates


makedocs(
    modules = [SeaweedFSClient],
    sitename="SeaweedFSClient.jl", 
    authors = "Matt Lawless",
    format = Documenter.HTML(),
)

deploydocs(
    repo = "github.com/lawless-m/SeaweedFSClient.jl.git", 
    devbranch = "main",
    push_preview = true,
)
