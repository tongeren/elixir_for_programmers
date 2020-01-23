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

    test "a good guess is recognized and my turns left are the same still" do
        game = Game.new_game("wibble")
        { game, _tally } = Game.make_move(game, "w")
        assert game.game_state == :good_guess
        assert game.turns_left == 7 
    end

    test "a guessed word is a won game" do
        moves = [
            {"w", :good_guess},
            {"i", :good_guess},
            {"b", :good_guess},
            {"l", :good_guess},
            {"e", :won}
        ]

        game = Game.new_game("wibble")

        fun = fn ({guess, state}, new_game) ->  
            {new_game, _tally} = Game.make_move(new_game, guess)
            assert new_game.game_state == state
            new_game
        end

        moves |> Enum.reduce(game, fun) 
             
    end 

    test "bad guess is recognized" do
        game = Game.new_game("wibble")
        { game, _tally } = Game.make_move(game, "x")
        assert game.game_state == :bad_guess
        assert game.turns_left == 6
    end

    test "lost game is recognized" do
        game = Game.new_game("w")
        { game, _tally } = Game.make_move(game, "a")
        assert game.game_state == :bad_guess
        assert game.turns_left == 6
        { game, _tally } = Game.make_move(game, "b")
        assert game.game_state == :bad_guess
        assert game.turns_left == 5
        { game, _tally } = Game.make_move(game, "c")
        assert game.game_state == :bad_guess
        assert game.turns_left == 4
        { game, _tally } = Game.make_move(game, "d")
        assert game.game_state == :bad_guess
        assert game.turns_left == 3
        { game, _tally } = Game.make_move(game, "e")
        assert game.game_state == :bad_guess
        assert game.turns_left == 2
        { game, _tally } = Game.make_move(game, "f")
        assert game.game_state == :bad_guess
        assert game.turns_left == 1
        { game, _tally } = Game.make_move(game, "g")
        assert game.game_state == :lost
        assert game.turns_left == 0
    end


  end