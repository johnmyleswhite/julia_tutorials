# and

# Write a function, symbols(e), that returns a Set{Symbol} containing all of the symbols in an expression. Remember that this requires descending the entire expression tree recursively.
# Write a function, free_vars(e), that returns a Set{Symbol} containing all of the symbols that are unbound in an anonymous function like x -> x + y. The output in that case should contain :+ and :y because function names are themselves symbols. As a hint, try using the symbols function from the previous exercise.
# Write a function, function_names(e), that returns all of the symbols in an anonymous function definition that must refer to something callable because they are called in the expression. For example, x -> sin(x) should return something containing :sin. But note that x -> Float64(x) should return Float64, so the results of this function aren't necessarily object whose type is a function -- you're just finding symbols bound to callables.
# Write a function, math_eval(e), that evaluates a purely mathematical expression like 1 + sin(2.0) and returns the result as a Float64 value. Do not just call eval; walk the expression manually and call out to +, *, etc. manually.

# loop
