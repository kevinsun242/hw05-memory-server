defmodule Memory do

  def newGame do
    tiles = Enum.shuffle([    
      %{value: "A", index: 0, matched: false, visible: false},
      %{value: "A", index: 1, matched: false, visible: false},
      %{value: "B", index: 2, matched: false, visible: false},
      %{value: "B", index: 3, matched: false, visible: false},
      %{value: "C", index: 4, matched: false, visible: false},
      %{value: "C", index: 5, matched: false, visible: false},
      %{value: "D", index: 6, matched: false, visible: false},
      %{value: "D", index: 7, matched: false, visible: false},
      %{value: "E", index: 8, matched: false, visible: false},
      %{value: "E", index: 9, matched: false, visible: false},
      %{value: "F", index: 10, matched: false, visible: false},
      %{value: "F", index: 11, matched: false, visible: false},
      %{value: "G", index: 12, matched: false, visible: false},
      %{value: "G", index: 13, matched: false, visible: false},
      %{value: "H", index: 14, matched: false, visible: false},
      %{value: "H", index: 15, matched: false, visible: false},
    ])
    %{
      clicks: 0,
      randomTiles: tiles, 
      matchedTiles: 0,
      flippedTiles: [],
    }
  end

  def client_view(game) do
    %{
      randomTiles: game.randomTiles,
      clicks: game.clicks,
      matchedTiles: game.matchedTiles,
      flippedTiles: game.flippedTiles,
    }
  end

  def flipTile(game, value, index) do
    if length(game.flippedTiles) == 2 do
      game = checkMatch(game)
    else 
      game = flipHelper(game, value, index)
      if length(game.flippedTiles) == 2 do
        game = checkMatch(game)
      else
        game
      end
    end
  end

  def flipHelper(game, value, index) do
    randomTiles = game.randomTiles
    flippedTiles = game.flippedTiles


    newRandomTiles = Enum.map(randomTiles, fn (tile) ->
      if Map.fetch!(tile, :value) == value && Map.fetch!(tile, :index) == index do
        Map.put(tile, :visible, true)
      else
        tile
      end
    end
    )

    newFlippedTiles = [%{value: value, index: index}] ++ flippedTiles

    game = Map.put(game, :randomTiles, newRandomTiles)
    game = Map.put(game, :flippedTiles, newFlippedTiles)
    game = Map.put(game, :clicks, game.clicks + 1)
  end

  def checkMatch(game) do
    clicks = game.clicks
    randomTiles = game.randomTiles
    flippedTiles = game.flippedTiles
    matchedTiles = game.matchedTiles

    tile1 = Enum.at(flippedTiles, 0)
    tile1index = tile1.index
    tile2 = Enum.at(flippedTiles, 1)
    tile2index = tile2.index

    if tile1.value == tile2.value do
    
      newRandomTiles = Enum.map(randomTiles, fn (tile) ->
        if Map.fetch!(tile, :value) == Map.fetch(tile1, :value) && Map.fetch!(tile, :index) == Map.fetch!(tile1, :index) do
          Map.put(tile, :matched, true)
        else
          tile
        end
        end
      )      
      newRandomTiles = Enum.map(randomTiles, fn (tile) ->
        if Map.fetch!(tile, :value) == Map.fetch(tile2, :value) && Map.fetch!(tile, :index) == Map.fetch!(tile2, :index) do
          Map.put(tile, :matched, true)
        else
          tile
        end
        end
      )  
      game = Map.put(game, :randomTiles, newRandomTiles)
      game = Map.put(game, :matchedTiles, matchedTiles + 2)
      game = Map.put(game, :flippedTiles, [])
      
    else
      newRandomTiles = Enum.map(randomTiles, fn (tile) ->
        if Map.fetch!(tile, :value) == Map.fetch(tile1, :value) && Map.fetch!(tile, :index) == Map.fetch!(tile1, :index) do
          Map.put(tile, :visible, false)
        else
          tile
        end
        end
      )  
      newRandomTiles = Enum.map(randomTiles, fn (tile) ->
        if Map.fetch!(tile, :value) == Map.fetch(tile2, :value) && Map.fetch!(tile, :index) == Map.fetch!(tile2, :index) do
          Map.put(tile, :visible, false)
        else
          tile
        end
        end
      )  
      game = Map.put(game, :randomTiles, newRandomTiles)
      game = Map.put(game, :flippedTiles, [])
      
    end
  end



end