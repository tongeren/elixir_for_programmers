defmodule GameTest do
    use ExUnit.Case
    
    alias Hangman.Game

    test "new_game returns structure" do
        game = Game.new_game()

        assert game.turns_left == 7
        assert game.game_state == :initializing
    end

    test "There are letters and they are only lower-case" do
        game = Game.new_game()
        letters = game.letters

        assert length(letters) > 0
        assert Enum.all?(letters, fn x -> String.match?(x, ~r/[[:lower:]]/) end )
    end

    test "state isn't changed for :won or :lost game" do
        for state <- [ :won, :lost ] do
            game = Game.new_game() |> Map.put(:game_state, state)
            assert { ^game, _ } = Game.make_move(game, "x")
        end
    end 

    test "first occurence of letter is not already used" do
        game = Game.new_game()
        { game, _tally } = Game.make_move(game, "x")
        assert game.game_state != :already_used
    end

    test "second occurence of letter is not already used" do
        game = Game.new_game()
        { game, _tally } = Game.make_move(game, "x")
        assert game.game_state != :already_used
        { game, _tally } = Game.make_move(game, "x")
        assert game.game_state == :already_used
    end


  end