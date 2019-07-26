module Smelt

using HTTP
using JSON

struct Response 
    error::AbstractString
    isabnormal::Bool
    message::AbstractString
end

function send(name::AbstractString, value::Number, api_key::AbstractString)
    response = HTTP.post("http://localhost:3000/send", 
        ["Content-Type" => "application/json"], 
        JSON.json(Dict(
                "api_key" => "870b6d79-75e4-48f6-ad49-e4ab2771667f",
                "name" => "Memory Usage",
                "value" => 14
                )
    ))

    body = String(response.body)
    d = JSON.parse(body)
    return Response(get(d, "error", ""), false, get(d, "message", ""))

end

end # module
