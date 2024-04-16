// Nathaniel Graves
import Foundation

struct Player
{
    let name: String;
    var hand: [Card];
    var chips: Int;
    var posted: Int;
    var folded: Bool;
    init(_ playerName: String, _ startingChips: Int)
    {
        name = playerName;
        hand = [];
        chips = startingChips;
        posted = 0;
        folded = false;
    }
}

let playerNames: [String] = [NSUserName(), "CPU1", "CPU2", "CPU3",
                             "CPU4", "CPU5", "CPU6", "CPU7"];

func nextPlayer(_ position: Int) -> Int
{
    var nextIndex: Int = position + 1;
    if (nextIndex >= (currentGame.players).count)
    {
        nextIndex -= (currentGame.players).count;
    }
    while ((currentGame.players)[nextIndex].folded || (currentGame.players)[nextIndex].chips == 0)
    {
        nextIndex += 1;
        if (nextIndex >= (currentGame.players).count)
        {
            nextIndex -= (currentGame.players).count;
        }
    }
    return nextIndex;
}

func prevPlayer(_ position: Int) -> Int
{
    var prevIndex: Int = position - 1;
    if (prevIndex < 0)
    {
        prevIndex += (currentGame.players).count;
    }
    while ((currentGame.players)[prevIndex].folded || (currentGame.players)[prevIndex].chips == 0)
    {
        prevIndex -= 1;
        if (prevIndex < 0)
        {
            prevIndex += (currentGame.players).count;
        }
    }
    return nextIndex;
}

func postBet(_ player: Player, _ amount: Int) -> Void
{
    var deficit: Int = amount - player.posted;
    if (player.chips >= deficit)
    {
        player.posted += deficit;
        player.chips -= deficit;
    }
    else
    {
        player.posted = player.chips;
        player.chips = 0;
    }
}
