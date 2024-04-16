// Nathaniel Graves
import Foundation

struct GameInfo
{
    var players: [Player];
    var inPlay: Int;
    var roundLimit: Int;
    var currentRound: Int;
    var currentPlayer: Int;
    var reviewPlayer: Int;
    var timesRaised: Int;
    var smallBlind: Int;
    var bigBlind: Int;
    var dealer: Int;
    var board: [Card];
}

var currentGame: GameInfo;

func newRound() -> Void
{
    currentGame.inPlay = 0;
    for player in currentGame.players
    {
        if (player.chips > 0)
        {
            currentGame.inPlay += 1;
            player.folded = false;
        }
    }
    currentGame.dealer = nextPlayer(currentGame.dealer);
    cardSet.shuffle();
    var dealTo: Int = nextPlayer(dealer);
    var nextCard: Int = 0;
    while (players[dealer].hand.count < 2)
    {
        players[dealTo].hand.append(Card(cardSet[nextCard], (dealTo == 0)));
        dealTo = nextPlayer(dealTo);
        nextCard += 1;
    }
    currentGame.board = [Card(cardSet[nextCard + 1], false),
                         Card(cardSet[nextCard + 2], false),
                         Card(cardSet[nextCard + 3], false),
                         Card(cardSet[nextCard + 5], false),
                         Card(cardSet[nextCard + 7], false)];
    if (currentGame.inPlay > 2)
    {
        (currentGame.players[nextPlayer(currentGame.dealer)]).posted += smallBet;
        (currentGame.players[nextPlayer(nextPlayer(currentGame.dealer))]).posted += bigBet;
        currentGame.currentPlayer = nextPlayer(nextPlayer(nextPlayer(currentGame.dealer)));
    }
    else
    {
        (currentGame.players[currentGame.dealer]).posted += smallBet;
        (currentGame.players[nextPlayer(currentGame.dealer)]).posted += bigBet;
        currentGame.currentPlayer = dealer;
    }
}

func fold(_ player: Player) -> Bool
{
    player.folded = true;
    inPlay -= 1;
    return false;
}

func call(_ player: Player) -> Bool
{
    if ((currentGame.board)[3].revealed)
    {
        postBet(player, 2 * timesRaised * bigBlind);
    }
    else
    {
        postBet(player, timesRaised * bigBlind);
    }
    return false;
}

func raise(_ player: Player) -> Bool
{
    if ((currentGame.board)[3].revealed)
    {
        postBet(player, 2 * timesRaised * bigBlind);
    }
    else
    {
        postBet(player, timesRaised * bigBlind);
    }
    currentGame.timesRaised += 1;
    return true;
}

func decision(_ player: Player) -> Bool
{
    return call(player);
}

func bettingRound() -> Bool
{
    currentGame.reviewPlayer = prevIndex(currentGame.currentPlayer);
    currentGame.timesRaised = 1;
    while (currentGame.currentPlayer != currentGame.reviewPlayer)
    {
        raised = decision(currentGame.currentPlayer);
        if (raised)
        {
            currentGame.reviewPlayer = currentGame.currentPlayer;
        }
        currentGame.currentPlayer = nextPlayer(currentGame.currentPlayer);
    }
    return currentGame.inPlay == 1;
}

func award() -> Void
{
    var won: [Int] = [];
    var pot: Int = 0;
    var playerAt: Int = 0;
    while (playerAt < (currentGame.players).count)
    {
        pot += (currentGame.players[playerAt]).posted;
        (currentGame.players[playerAt]).posted = 0;
        if (!(currentGame.players[playerAt].folded))
        {
            won.append(playerAt);
        }
    }
    for winner in won
    {
        (currentGame.players[winner]).chips += (pot / won.count);
    }
    var tiebreaker: Int = dealer;
    while (pot > 0)
    {
        if (won.contains(tiebreaker))
        {
            (currentGame.players[tiebreaker]).chips += 1;
            pot -= 1;
        }
        tiebreaker = nextPlayer(tiebreaker);
    }
}

func gameRound() -> Void
{
    var concession: Bool;
    concession = bettingRound();
    if (concession)
    {
        award();
        return;
    }
    (currentGame.board).revealed[0] = true;
    (currentGame.board).revealed[1] = true;
    (currentGame.board).revealed[2] = true;
    currentGame.currentPlayer = nextPlayer(currentGame.dealer);
    bettingRound();
    if (concession)
    {
        award();
        return;
    }
    (currentGame.board).revealed[3] = true;
    currentGame.currentPlayer = nextPlayer(currentGame.dealer);
    bettingRound();
    if (concession)
    {
        award();
        return;
    }
    (currentGame.board).revealed[4] = true;
    currentGame.currentPlayer = nextPlayer(currentGame.dealer);
    bettingRound();
    if (concession)
    {
        award();
        return;
    }
    for player in currentGame.players
    {
        (player.hand[0]).revealed = true;
        (player.hand[1]).revealed = true;
    }
    let handed: [Int] = bestHand(handidates());
    var playerAt: Int = 0;
    while (playerAt < (currentGame.players).count)
    {
        if (!handed.contains(playerAt))
        {
            currentGame.players[playerAt].folded = true;
        }
    }
    award();
}
