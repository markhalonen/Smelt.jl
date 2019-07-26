module Smelt

using HTTP
using JSON

struct Response 
    error::AbstractString
    isabnormal::Bool
    message::AbstractString
end

function send(name::AbstractString, value::Number, api_key::AbstractString)
    response = HTTP.post("https://secure-eyrie-26607.herokuapp.com/send", 
        ["Content-Type" => "application/json"], 
        JSON.json(Dict("api_key" => api_key,
                "name" => name,
                "value" => value)))

    body = String(response.body)
    d = JSON.parse(body)
    return Response(get(d, "error", ""), false, get(d, "message", ""))

end

end # module
