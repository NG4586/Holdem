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
    init()
    {
        players = [];
        inPlay = 0;
        roundLimit = 0;
        currentRound = 0;
        currentPlayer = 0;
        reviewPlayer = 0;
        timesRaised = 0;
        smallBlind = 0;
        bigBlind = 0;
        dealer = 0;
        board = [];
    }
}

var currentGame: GameInfo = GameInfo();

func fold(_ player: Int) -> Bool
{
    (currentGame.players[player]).folded = true;
    currentGame.inPlay -= 1;
    return false;
}

func call(_ player: Int) -> Bool
{
    if ((currentGame.board)[3].revealed)
    {
        postBet(player, 2 * currentGame.timesRaised * currentGame.bigBlind);
    }
    else
    {
        postBet(player, currentGame.timesRaised * currentGame.bigBlind);
    }
    return false;
}

func raise(_ player: Int) -> Bool
{
    if ((currentGame.board)[3].revealed)
    {
        postBet(player, 2 * currentGame.timesRaised * currentGame.bigBlind);
    }
    else
    {
        postBet(player, currentGame.timesRaised * currentGame.bigBlind);
    }
    currentGame.timesRaised += 1;
    return true;
}

func decision(_ player: Int) -> Bool
{
    return call(player);
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
        playerAt += 1;
    }
    for winner in won
    {
        (currentGame.players[winner]).chips += (pot / won.count);
    }
    var tiebreaker: Int = currentGame.dealer;
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

func bettingRound() -> Bool
{
    currentGame.reviewPlayer = prevPlayer(currentGame.currentPlayer);
    var raised: Bool = true;
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

func gameRound() -> Void
{
    currentGame.inPlay = 0;
    var playerAt: Int = 0;
    while (playerAt < (currentGame.players).count)
    {
        if ((currentGame.players)[playerAt].chips > 0)
        {
            currentGame.inPlay += 1;
            (currentGame.players)[playerAt].folded = false;
        }
        playerAt += 1;
    }
    currentGame.dealer = nextPlayer(currentGame.dealer);
    cardSet.shuffle();
    var dealTo: Int = nextPlayer(currentGame.dealer);
    var nextCard: Int = 0;
    while ((currentGame.players[currentGame.dealer]).hand.count < 2)
    {
        (currentGame.players)[dealTo].hand.append(Card(cardSet[nextCard], (dealTo == 0)));
        dealTo = nextPlayer(dealTo);
        nextCard += 1;
    }
    if (currentGame.inPlay > 2)
    {
        (currentGame.players[nextPlayer(currentGame.dealer)]).posted +=
            currentGame.smallBlind;
        (currentGame.players[nextPlayer(nextPlayer(currentGame.dealer))]).posted +=
            currentGame.bigBlind;
        currentGame.currentPlayer = nextPlayer(nextPlayer(nextPlayer(currentGame.dealer)));
    }
    else
    {
        (currentGame.players[currentGame.dealer]).posted += currentGame.smallBlind;
        (currentGame.players[nextPlayer(currentGame.dealer)]).posted += currentGame.bigBlind;
        currentGame.currentPlayer = currentGame.dealer;
    }
    currentGame.board = [Card(cardSet[nextCard + 1], false),
                         Card(cardSet[nextCard + 2], false),
                         Card(cardSet[nextCard + 3], false),
                         Card(cardSet[nextCard + 5], false),
                         Card(cardSet[nextCard + 7], false)];
    var concession: Bool;
    concession = bettingRound();
    if (concession)
    {
        award();
        return;
    }
    (currentGame.board)[0].revealed = true;
    (currentGame.board)[1].revealed = true;
    (currentGame.board)[2].revealed = true;
    currentGame.currentPlayer = nextPlayer(currentGame.dealer);
    concession = bettingRound();
    if (concession)
    {
        award();
        return;
    }
    (currentGame.board)[3].revealed = true;
    currentGame.currentPlayer = nextPlayer(currentGame.dealer);
    concession = bettingRound();
    if (concession)
    {
        award();
        return;
    }
    (currentGame.board)[4].revealed = true;
    currentGame.currentPlayer = nextPlayer(currentGame.dealer);
    concession = bettingRound();
    if (concession)
    {
        award();
        return;
    }
    playerAt = 0;
    while (playerAt < (currentGame.players).count)
    {
        ((currentGame.players)[playerAt].hand[0]).revealed = true;
        ((currentGame.players)[playerAt].hand[1]).revealed = true;
        playerAt += 1;
    }
    let handed: [Int] = bestHand(handidates());
    playerAt = 0;
    while (playerAt < (currentGame.players).count)
    {
        if (!handed.contains(playerAt))
        {
            currentGame.players[playerAt].folded = true;
        }
    }
    award();
}
