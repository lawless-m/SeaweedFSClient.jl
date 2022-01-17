module SeaweedFSClient

using HTTP, JSON, Pipe

# Write your package code here.

export create, save, read, filedata, delete

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
#Arguments
`h` an instance of NamedTuple{(:hostname, :port), Tuple{String, Int64}}
"""
create(h::Host) = @pipe HTTP.request("GET", "http://$(h.hostname):$(h.port)/dir/assign") |> decode_response(h,_)

"""
    save(f::NamedTuple, file_data)
    save(h::Host, url, fid, file_data)
Send the file_data to the fid. file_data is created using filedata()
"""
save(f::NamedTuple, form::HTTP.Form) = save(f.host, f.url, f.fid, form)
save(h::Host, url, fid, form::HTTP.Form) = @pipe HTTP.post("http://$url/$fid", [], form) |> decode_response(h,_)

"""
    read(f::NamedTuple, options=Dict{String,String}())::Vector{UInt8}
read a file from the server
Arguments
For some files the server will do actions. The documented one is width=W, height=H and mode=fit|fill - perhaps more will follow
"""
function read(f::NamedTuple, options=Dict{String,String}())
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
    delete(url, fid) 
    delete(f::NamedTuple) 

Delete a file from the server
"""
delete(url, fid) = HTTP.request("DELETE", "http://$url/$fid")
delete(f::NamedTuple) = delete(f.url, f.fid)

"""
    filedata(filename, text)
    filedata(filename::AbstractString)
    filedata(filename::AbstractString, io::IO)

Create a file data object to send to the server
"""
filedata(filename, text) = HTTP.Form(Dict("text"=>text))
filedata(filename::AbstractString) = file_form(filename, open(filename))
filedata(filename::AbstractString, io::IO) = HTTP.Form(Dict("key" => HTTP.Multipart(filename, io, HTTP.sniff(io)),))


###
end
