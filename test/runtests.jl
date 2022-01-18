using SeaweedFSClient
using Test

fid = ()

function test_create()
    global fid
    fid = create((hostname="localhost", port=9333))
    fid !== nothing && fid.status == 200
end

function test_save()
    global fid
    r = save(fid, filedata("123456"))
    r !== nothing && r.status == 201
end

function test_load()
    global fid
    r = String(load(fid, range=0:2))
    r == "123"
end

function test_delete()
    global fid
    r = delete(fid)
    r !== nothing && r.status == 202
end

@testset "SeaweedFSClient.jl" begin
    if isdir("/trip") # then localhost and SeaweedFS server is present
        @test test_create()
        @test test_save()
        @test test_load()
        @test test_delete()
    end
end
