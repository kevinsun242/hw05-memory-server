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
      game = flipHelper(game, value, index);
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

    newRandomTiles = List.replace_at(randomTiles, index, Map.put(Enum.at(randomTiles, index), :visible, true))
    newFlippedTiles = [%{value: value, index: index}]++ flippedTiles

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
      newRandomTiles = List.replace_at(randomTiles, tile1index, Map.put(Enum.at(randomTiles, tile1index), :matched, true))
      newRandomTiles = List.replace_at(randomTiles, tile2index, Map.put(Enum.at(randomTiles, tile2index), :matched, true))

      %{
        clicks: clicks,
        randomTiles: newRandomTiles,
        matchedTiles: matchedTiles + 2,
        flippedTiles: [],
      }
    else      
      newRandomTiles = List.replace_at(randomTiles, tile1index, Map.put(Enum.at(randomTiles, tile1index), :visible, false))
      newRandomTiles = List.replace_at(randomTiles, tile1index, Map.put(Enum.at(randomTiles, tile1index), :visible, false))

      %{
        clicks: clicks,
        randomTiles: newRandomTiles,
        matchedTiles: matchedTiles,
        flippedTiles: [],
      }
    end
  end



end