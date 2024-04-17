// Nathaniel Graves
import Foundation

struct Player: Identifiable
{
    let id: String;
    var hand: [Card];
    var chips: Int;
    var posted: Int;
    var folded: Bool;
    init(_ playerName: String, _ startingChips: Int)
    {
        id = playerName;
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
    return prevIndex;
}

func postBet(_ player: Int, _ amount: Int) -> Void
{
    let deficit: Int = amount - (currentGame.players[player]).posted;
    if ((currentGame.players[player]).chips >= deficit)
    {
        (currentGame.players[player]).posted += deficit;
        (currentGame.players[player]).chips -= deficit;
    }
    else
    {
        (currentGame.players[player]).posted = (currentGame.players[player]).chips;
        (currentGame.players[player]).chips = 0;
    }
}
