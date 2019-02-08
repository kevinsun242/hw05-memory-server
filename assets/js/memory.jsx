import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';
import $ from 'jquery';

export default function  memory_init(root, channel) {
  ReactDOM.render(<Memory channel={channel} />, root);
}


class Memory extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      clicks: 0,
      randomTiles: [],
      matchedTiles: 0,
      flippedTiles: [],
    };

    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => {console.log("Unable to join", resp) });
  }

  gotView(view) {
    console.log("new view", view);
    this.setState(view.game);
  }

/*
  reset() {
    this.setState({
      clicks: 0,
      randomTiles: this.generateTiles(),
      matchedTiles: 0,
      flippedTiles: [],
    });
  }
*/

  flipTile(value, index) {
    this.channel.push("flipTile", {value: value, index: index})
    .receive("ok", this.gotView.bind(this))
    .receive("checkMatch", this.checkMatch.bind(this));
  }

  checkMatch(view){
    this.gotView(view);
    setTimeout(() => {this.channel.push("checkMatch").receive("ok", this.gotView.bind(this))}, 1000);
  }

  reset(ev) {
    this.channel.push("reset")
    .receive("ok", this.gotView.bind(this))
  }



  render() {
    console.log("render");
    let tiles = _.map(this.state.randomTiles, (tile, index) => {
      return <TileItem tile={tile} flipTile={this.flipTile.bind(this)} key={index} />;
    });

    let winText = ""
    if (this.state.matchedTiles == 16) {
      winText = "You Win!";
    }

    return (
      <div className="Game">
        <h1>Memory Game</h1>
        <div className="Board">{tiles}</div>
        <div><p className="WinText">{winText}</p></div>
        <div className="Reset"><ResetButton reset={this.reset.bind(this)}/></div>
        <div className="Clicks"><p>Number of clicks taken: {this.state.clicks}</p></div>
      </div>) 
  };
}

function TileItem(props) {
  let tile = props.tile;
  if (tile.matched) {
    return <button className="Tile" id={tile.index} disabled>{tile.value}</button>
  }
  else if (tile.visible) {
    return <button className="Tile" id={tile.index} disabled>{tile.value}</button>
  }
  else {
    return <button className="Tile" id={tile.index} onClick={() => props.flipTile(tile.value, tile.index)}>Tile</button>
  }
}

function ResetButton(props) {
  return <button className="ResetButton" id="reset" onClick={() => props.reset()}>Reset Game</button>
}
