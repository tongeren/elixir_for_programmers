defmodule Hangman do
  alias Hangman.Game

  defdelegate new_game,    to: Game
  defdelegate tally(game), to: Game

  def make_move(game, guess) do
    if single_ascii_character?(guess) do
      game = Game.make_move(game, guess)
      { game, tally(game) }
    else
      { game, tally(game) }
    end
  end

  # PRIVATE ----------------------------- 
  
  defp single_ascii_character?(str) do
    str |> String.match?(~r/\A[a-z]$/)
  end
end
