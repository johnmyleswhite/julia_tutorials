macro _tvl_or(x, y)
    t1 = gensym()
    quote
        let $t1 = $x
            if $t1 === true
                true
            elseif $t1 === false
                $y
            else
                if $y === true
                    true
                else
                    missing
                end
            end
        end
    end
end

macro _tvl_and(x, y)
    t1 = gensym()
    quote
        let $t1 = $x
            if $t1 === false
                false
            elseif $t1 === true
                $y
            else
                if $y === false
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
            Symbol("@_tvl_and"),
            LineNumberNode(0, nothing),
            esc(replace_and_or(e.args[1])),
            esc(replace_and_or(e.args[2])),
        )
    elseif e.head == :||
        Expr(
            :macrocall,
            Symbol("@_tvl_or"),
            LineNumberNode(0, nothing),
            esc(replace_and_or(e.args[1])),
            esc(replace_and_or(e.args[2])),
        )
    else
        Expr(
            e.head,
            map(ex->esc(replace_and_or(ex)), e.args)...
        )
    end
end

macro tvl(e)
    replace_and_or(e)
end
