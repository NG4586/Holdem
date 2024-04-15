// Nathaniel Graves
import Foundation

struct Player
{
    let name: String;
    var hand: [Card];
    var chips: Int;
    init(_ playerName: String, _ startingChips: Int)
    {
        name = playerName;
        hand = [];
        chips = startingChips;
    }
}

let playerNames: [String] = [NSUserName(), "CPU1", "CPU2", "CPU3",
                             "CPU4", "CPU5", "CPU6", "CPU7"];

var players: [Player] = [];

var numPlayers: Int;

var dealer: Int;

func nextPlayer(_ position: Int) -> Int
{
    var nextIndex: Int = (position + 1) % numPlayers;
    while (players[nextIndex].chips == 0)
    {
        nextIndex = (nextIndex + 1) % numPlayers;
    }
    return nextIndex;
}
