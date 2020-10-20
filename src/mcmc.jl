# stolen from python implementation
# https://technicallyagarwal.wordpress.com/2018/02/06/markov-chain-algorithm/

using Printf, Random


mutable struct Table
    prefixVec::Vector{Tuple{String, String}}
    suffixVec::Vector{String}
    Table() = new(Vector{Tuple{String,String}}(), Vector{String}())
end

function Table(s::String)
    splits = split(s)
    buffer = Table()
    for i in eachindex(splits[1:end-2])
        prefixes::Tuple{String, String} = tuple(String(splits[i]),
                                                String(splits[i+1]))
        suffix::String = splits[i+2]
        if !(prefixes in buffer.prefixVec)
            push!(buffer.prefixVec, prefixes)
            push!(buffer.suffixVec, suffix)
        end
    end
    return buffer
end

function lookup(prefix::Tuple{String, String}, table::Table)
   index::Union{Nothing,Int64} = findfirst(x-> prefix == x, table.prefixVec)
    if index != nothing
        return table.suffixVec[index]
    end
    return ""
end

function generate_markov_text(table::Table)
    buffer = ""
    n::Int64 = rand(20:100)
    items = shuffle(table.prefixVec), shuffle(table.suffixVec)
    currentPrefixes, currentSuffixes = items[1][1], items[2][1]
    buffer = @sprintf("%s %s ", currentPrefixes[1], currentPrefixes[2])

    for i in 1:n
        if isempty(currentSuffixes)
            currentPrefixes = rand(items[1])
            currentSuffixes = rand(items[2])
        else
            word = rand(items[2])
            buffer *= @sprintf("%s ", word)
            currentPrefixes = (currentPrefixes[2], word)
            currentSuffixes = lookup(currentPrefixes, table)
        end
    end

    return buffer
end

function generate_markov_from_string(s::String)
    temp = Table(s)
    gen_text = generate_markov_text(temp)
    return gen_text
end

