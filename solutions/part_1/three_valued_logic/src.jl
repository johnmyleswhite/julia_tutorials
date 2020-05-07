# TODO: This is non-hygienic as written if the inputs x or y refer to
# tmp1 or tmp2. To fix, should replace tmp1 and tmp2 with custom symbols
# from calling gensym.
macro tvl_or(x, y)
    quote
        let tmp1 = $(esc(x))
            if tmp1 === true
                true
            elseif tmp1 === false
                $(esc(y))
            else
                if $(esc(y)) === true
                    true
                else
                    missing
                end
            end
        end
    end
end

# TODO: This is non-hygienic as written if the inputs x or y refer to
# tmp1 or tmp2. To fix, should replace tmp1 and tmp2 with custom symbols
# from calling gensym.
macro tvl_and(x, y)
    quote
        let tmp1 = $(esc(x))
            if tmp1 === false
                false
            elseif tmp1 === true
                $(esc(y))
            else
                if $(esc(y)) === false
                    false
                else
                    missing
                end
            end
        end
    end
end

replace_and_or(e::Any) = e

function replace_and_or(e::Expr)
    if e.head == :&&
        Expr(
            :macrocall,
            Symbol("@tvl_and"),
            LineNumberNode(0, nothing),
            replace_and_or(e.args[1]),
            replace_and_or(e.args[2]),

        )
    elseif e.head == :||
        Expr(
            :macrocall,
            Symbol("@tvl_or"),
            LineNumberNode(0, nothing),
            replace_and_or(e.args[1]),
            replace_and_or(e.args[2]),
        )
    else
        Expr(
            e.head,
            map(replace_and_or, e.args)...
        )
    end
end

# TODO: Move esc to a better place? The macro expansions are all
# let blocks, so there's potentially shadowing, but no leakage,
# of variables AFAIK.
macro tvl(e)
    esc(replace_and_or(e))
end
