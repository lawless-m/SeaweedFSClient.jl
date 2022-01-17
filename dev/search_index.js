var documenterSearchIndex = {"docs":
[{"location":"#SeaweedFSClient.jl","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.jl","text":"","category":"section"},{"location":"","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.jl","text":"Some of these actions will throw exceptions via the HTTP client e.g. doing delete(f) on a deleted file","category":"page"},{"location":"","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.jl","text":"create","category":"page"},{"location":"#SeaweedFSClient.create","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.create","text":"create(h::Host)\n\nArguments\n\nh an instance of NamedTuple{(:hostname, :port), Tuple{String, Int64}}\n\nExample\n\njulia> f = create((hostname=\"localhost\", port=9333))\n(host = (hostname = \"localhost\", port = 9333), status = 200, url = \"192.168.1.9:8080\", publicUrl = \"192.168.1.9:8080\", count = 1, fid = \"3,09b8e10215\"\n\n\n\n\n\n","category":"function"},{"location":"","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.jl","text":"filedata","category":"page"},{"location":"#SeaweedFSClient.filedata","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.filedata","text":"filedata(filename, text)\nfiledata(filename::AbstractString)\nfiledata(filename::AbstractString, io::IO)\n\nCreate a file data object to send to the server\n\nExample\n\n# using a created f\njulia> save(f, filedata(\"/home/matt/readme.txt\"))\n(host = (hostname = \"localhost\", port = 9333), status = 201, eTag = \"04fd3fe2\", name = \"readme.txt\", size = 29)\n\n\n\n\n\n","category":"function"},{"location":"","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.jl","text":"save","category":"page"},{"location":"#SeaweedFSClient.save","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.save","text":"save(f::NamedTuple, file_data)\nsave(h::Host, url, fid, file_data)\n\nArguments\n\nf is the response returned from create (or any tuple with (host=(hostname=String, port=Int), fid=\"V,FID\", url=\"http...\")) Send the file_data to the fid. file_data is created using filedata()\n\nExample\n\n# using a created f\njulia> save(f, filedata(\"readme.txt\", \"This is some text\"))\n(host = (hostname = \"localhost\", port = 9333), status = 201, eTag = \"0d79b2b0\", size = 17)\n\n\n\n\n\n\n","category":"function"},{"location":"","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.jl","text":"load","category":"page"},{"location":"#SeaweedFSClient.load","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.load","text":"load(f::NamedTuple, options=Dict{String,String}())::Vector{UInt8}\n\nExample\n\n```\n\nusing a created f\n\njulia> load(f) 17-element Vector{UInt8}: 0x54 0x68 ... 0x20 0x74  ```\n\n\n\n\n\n","category":"function"},{"location":"","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.jl","text":"delete","category":"page"},{"location":"#SeaweedFSClient.delete","page":"SeaweedFSClient.jl","title":"SeaweedFSClient.delete","text":"delete(f::NamedTuple) \ndelete(url, fid)\n\nArguments\n\nf is the response returned from create (or any tuple with (host=(hostname=String, port=Int), fid=\"V,FID\", url=\"http...\")) Delete a file from the server\n\nExample\n\n# using a created f\njulia> delete(f)\n(host = nothing, status = 202, size = 29)\n\n\n\n\n\n","category":"function"}]
}
