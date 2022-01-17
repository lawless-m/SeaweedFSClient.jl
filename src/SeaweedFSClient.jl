module SeaweedFSClient

using HTTP, JSON, Pipe

export create, save, load, filedata, delete

const Host = NamedTuple{(:hostname, :port), Tuple{String, Int64}}

function decode_response(h, r)
    if 200 <= r.status < 300
        json = String(r.body)
        if length(json) > 0
            return (host=h, status=r.status, Dict(Symbol(k)=>v for (k,v) in JSON.parse(json))...)
        end
    end
    return (host=h, status=r.status,)
end

volume(f::NamedTuple) = volume(f.fid)
volume(fid::AbstractString) = split(fid, ",")[1]

server(f::NamedTuple) = server(f.host, volume(f))
server(h::Host, v::AbstractString) = @pipe HTTP.request("GET", "http://$(h.hostname):$(h.port)/dir/lookup?volumeId=$(v)") |> decode_response(h,_)

"""
    create(h::Host)
# Arguments
`h` an instance of NamedTuple{(:hostname, :port), Tuple{String, Int64}}
# Example
```
julia> f = create((hostname="localhost", port=9333))
(host = (hostname = "localhost", port = 9333), status = 200, url = "192.168.1.9:8080", publicUrl = "192.168.1.9:8080", count = 1, fid = "3,09b8e10215"
```
"""
create(h::Host) = @pipe HTTP.request("GET", "http://$(h.hostname):$(h.port)/dir/assign") |> decode_response(h,_)

"""
    save(f::NamedTuple, file_data)
    save(h::Host, url, fid, file_data)
# Arguments
`f` is the response returned from `create` (or any tuple with (host=(hostname=String, port=Int), fid="V,FID", url="http..."))
Send the `file_data` to the fid. `file_data` is created using `filedata()`
# Example

```
# using a created f
julia> save(f, filedata("readme.txt", "This is some text"))
(host = (hostname = "localhost", port = 9333), status = 201, eTag = "0d79b2b0", size = 17)

```
"""
save(f::NamedTuple, form::HTTP.Form) = save(f.host, f.url, f.fid, form)
save(h::Host, url, fid, form::HTTP.Form) = @pipe HTTP.post("http://$url/$fid", [], form) |> decode_response(h,_)

"""
    load(f::NamedTuple, options=Dict{String,String}())::Vector{UInt8}
load a file from the server
# Arguments
`f` is the response returned from `create` (or any tuple with (host=(hostname=String, port=Int), fid="V,FID", url="http..."))
For some files the server will do actions. The documented one is width=W, height=H and `mode in ["fit", "fill"]` - perhaps more will follow

# Example
```
# using a created f
julia> load(f)
17-element Vector{UInt8}:
 0x54
 0x68
    ⋮
 0x20
 0x74
 ```
"""
function load(f::NamedTuple, options=Dict{String,String}())::Vector{UInt8}
    srv = server(f)
    if srv.status == 200
        url = srv.locations[1]["url"]
        qs = ""
        if haskey(options, "width") && haskey(options, "height")
            qs = """?width=$(options["width"])&height=$(options["height"])&mode=$(get(options, "mode", ""))"""
        end
        r = HTTP.request("GET", "http://$(url)/$(f.fid)$qs")
        if r.status == 200
            return r.body
        end
    end
end

"""
    delete(f::NamedTuple) 
    delete(url, fid) 
# Arguments
`f` is the response returned from `create` (or any tuple with (host=(hostname=String, port=Int), fid="V,FID", url="http..."))
Delete a file from the server
# Example
```
# using a created f
julia> delete(f)
(host = nothing, status = 202, size = 29)
```
"""
delete(f::NamedTuple) = delete(f.url, f.fid)
delete(url, fid) = @pipe HTTP.request("DELETE", "http://$url/$fid") |> decode_response(nothing, _)
"""
    filedata(filename, text)
    filedata(filename::AbstractString)
    filedata(filename::AbstractString, io::IO)

Create a file data object to send to the server
# Example
```
# using a created f
julia> save(f, filedata("/home/matt/readme.txt"))
(host = (hostname = "localhost", port = 9333), status = 201, eTag = "04fd3fe2", name = "readme.txt", size = 29)
```
"""
filedata(filename, text) = HTTP.Form(Dict("text"=>text))
filedata(filename::AbstractString) = filedata(filename, open(filename))
filedata(filename::AbstractString, io::IO) = HTTP.Form(Dict("key" => HTTP.Multipart(filename, io, HTTP.sniff(io)),))


###
end
