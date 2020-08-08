module mcmc

# stolen from python implementation
# https://technicallyagarwal.wordpress.com/2018/02/06/markov-chain-algorithm/

using Printf
using Random

function Table(s::String)
    splits = split(s)
    buffer = Dict{Vector{String}, String}()
    for i in eachindex(splits[1:end-2])
        prefixes, suffix = splits[i:i+1], splits[i+2]
        if !haskey(buffer, prefixes)
            buffer[prefixes] = suffix
        end
    end
    return buffer
end

function lookup(prefix, table)
    if prefix in keys(table)
        return table[prefix]
    end
    return ""
end

function generate(table)
    buffer = ""
    n::Int64 = 15
    items = shuffle(collect(table))
    currentPrefixes, currentSuffixes = items[1][1], items[1][2]
    buffer = @sprintf("%s %s ", currentPrefixes[1], currentPrefixes[2])

    for i in 1:n
        if currentSuffixes == "" || currentPrefixes == ["",""]
            randomvec = rand(items)
            currentPrefixes = randomvec[1]
            currentSuffixes = randomvec[2]
        else
            word = rand(items)[2]
            buffer *= @sprintf("%s ", word)
            currentPrefixes = [currentPrefixes[2], word]
            currentSuffixes = lookup(currentPrefixes, table)
        end
    end

    return buffer
end

function generate_from_string(s::String)
    temp = Table(s)
    return generate(temp)
end


end # module
