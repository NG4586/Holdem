// Nathaniel Graves
import Foundation

var buyIn: Int;

var minBet: Int;

var posted: Dictionary<Int, Int>;

func fold(_ player: Int) -> Bool
{
    (posted[numPlayers]!) += (posted[player]!);
    posted.removeValue(forKey: player);
    return false;
}

func bet(_ player: Int) -> Bool
{
    var deficit: Int = currentBet - (posted[player]!);
    if (players[player].chips >= deficit)
    {
        (posted[player]!) += deficit;
        players[player].chips -= deficit;
    }
    else
    {
        (posted[player]!) += players[player].chips;
        players[player].chips = 0;
    }
    return true;
}

func decision(_ player: Int, _ raises: Int) -> (Int -> Bool)
{
    if (player == 0)
    {
        //
    }
    return call;
}

func bettingRound(_ matchingTo: Int, _ maxRaise: Int) -> Void
{
    var currentPlayer: Int = matchingTo;
    var raised: Bool = true;
    while (raised)
    {
        raised = false;
        currentPlayer = nextPlayer(matchingTo);
        while (currentPlayer != matchingTo)
        {
            //
        }
    }
}

var currentHand: Int
{
    didSet
    {
        cardSet.shuffle();
        var dealTo: Int = nextPlayer(dealer);
        var nextCard: Int = 0;
        while (players[dealer].hand.count < 2)
        {
            players[dealTo].hand.append(Card(cardSet[nextCard], (dealTo == 0)));
            dealTo = nextPlayer(dealTo);
        }
        if (posted.count > 2)
        {
            posted[nextPlayer(dealer)] = minBet / 2;
            posted[nextPlayer(nextPlayer(dealer))] = minBet;
        }
        else
        {
            posted[dealer] = minBet / 2;
            posted[nextPlayer(dealer)] = minBet;
        }
        for n: Int in (0 ..< numPlayers)
        {
            if (players[n].chips > 0 && posted[n] != nil)
            {
                posted[n] = 0;
            }
        }
        posted[numPlayers] = 0;
        // here
    }
}

var initiated: Bool
{
    didSet
    {
        if (initiated == true)
        {
            var nextPlayer: Int = 0;
            var currentPlayers: [Player] = [];
            while (nextPlayer < numPlayers)
            {
                currentPlayers.append(Player(playerNames[nextPlayer], buyIn));
                nextPlayer += 1;
            }
            players = currentPlayers;
            dealer = Int.random(in: 0 ..< numPlayers);
            currentHand = 0;
        }
    }
}
