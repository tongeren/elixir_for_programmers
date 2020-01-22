# mix run --no-mix-exs pythag.exs

# :timer.tc(
#     fn -> 
#         for a <- 1..99, 
#             b <- 1..99, 
#             c <- 1..99, 
#             a * a + b * b == c * c, 
#         do: [a, b, c] 
# end) |> inspect(charlists: :as_lists)

:timer.tc(
    fn -> 
        for a <- 1..99, 
            b <- a+1..99, 
            c = :math.sqrt(a * a + b * b),
            Float.ceil(c) == Float.floor(c),
            c <= 99,  
        do: [a, b, round(c)] 
end) |> inspect(charlists: :as_lists) |> IO.puts