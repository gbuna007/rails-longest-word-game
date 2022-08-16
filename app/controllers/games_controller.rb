class GamesController < ApplicationController
  def new
    @letters = []

    10.times do
      char = Array('A'..'Z').sample.first
      @letters << char
    end
  end

  def score
    raise
  end
end
