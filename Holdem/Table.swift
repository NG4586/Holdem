// Nathaniel Graves
import SwiftUI

class Table
{
    var controller: Engagement;
    var players: [Player] = [];
    var board: Board;
    var deck: Deck;
    let blind: Int;
    var dealer: Int;
    var currentBet: Int;
    var raiseSteps: [Int];
    var currentPlayer: Player? = nil
    {
        didSet
        {
            if (currentPlayer != nil)
            {
                if ((currentPlayer!).action != "fold" && (currentPlayer!).action != "out")
                {
                    controller.yourTurn = (currentPlayer!).user;
                    (currentPlayer!).action = "pending";
                }
                else
                {
                    turnComplete();
                }
            }
        }
    }
    func setCurrentPlayer(_ player: Player) -> Void
    {
        currentPlayer = player;
    }
    var playerIndex: Int;
    func userAction(_ input: Option) -> Void
    {
        if (currentPlayer != nil)
        {
            controller.yourTurn = false;
            if (input.name == "call")
            {
                (currentPlayer!).post(currentBet);
            }
            else if (input.name == "raise")
            {
                (currentPlayer!).post(raiseSteps[0]);
            }
            (currentPlayer!).action = input.name;
        }
    }
    var roundState: String = "pre-flop";
    func unraised() -> Bool
    {
        var playerAt: Int = 0;
        while (playerAt < players.count)
        {
            if (playerAt != playerIndex && (players[playerAt].action == "raise"
                                            || players[playerAt].action == "ready"))
            {
                return false;
            }
            playerAt += 1;
        }
        return true;
    }
    func advanceRound() -> Void
    {
        if (roundState == "pre-flop" || roundState == "flop")
        {
            raiseSteps = [blind, (blind * 2), (blind * 3)];
        }
        else
        {
            raiseSteps = [(blind * 2), (blind * 4), (blind * 6)];
        }
        for n: Int in 0 ..< raiseSteps.count
        {
            raiseSteps[n] += currentBet;
        }
        for player: Player in players
        {
            if (player.action != "fold" && player.action != "out")
            {
                player.action = "ready";
            }
        }
        playerIndex = (dealer + 1) % players.count;
        currentPlayer = players[playerIndex];
    }
    func award(_ winners: [Player], _ amount: Int) -> Void
    {
        for winner: Player in winners
        {
            winner.chips += (amount / winners.count);
        }
        // todo: split remainder
    }
    func defaultWin() -> Bool
    {
        var stillIn: [Player] = [];
        for player: Player in players
        {
            if (player.action != "fold" && player.action != "out")
            {
                stillIn.append(player);
            }
        }
        if (stillIn.count <= 1)
        {
            var pot: Int = 0;
            for player: Player in players
            {
                pot += player.posted;
                player.posted = 0;
            }
            award(stillIn, pot);
            return true;
        }
        return false;
    }
    func turnComplete() -> Void
    {
        if (unraised())
        {
            if (!defaultWin())
            {
                if (roundState == "pre-flop")
                {
                    roundState = "flop"
                    board.flop(deck);
                    advanceRound();
                }
                else if (roundState == "flop")
                {
                    roundState = "turn"
                    board.turn(deck);
                    advanceRound();
                }
                else if (roundState == "turn")
                {
                    roundState = "river"
                    board.river(deck);
                    advanceRound();
                }
                else if (roundState == "river")
                {
                    var handSet: [Hand] = [];
                    var heldBy: Dictionary<Player, Hand> = [:];
                    var pot: Int = 0;
                    for player: Player in players
                    {
                        if (player.action != "fold" && player.action != "out")
                        {
                            (player.cards)[0].reveal();
                            (player.cards)[1].reveal();
                            heldBy[player] = player.bestHand();
                            handSet.append((heldBy[player])!);
                        }
                        pot += player.posted;
                        player.posted = 0;
                    }
                    handSet.sort();
                    var won: [Player] = [];
                    for playerHand: (key: Player, value: Hand) in heldBy
                    {
                        if (playerHand.value == (handSet.last!))
                        {
                            won.append(playerHand.key);
                        }
                    }
                    award(won, pot);
                    controller.roundEnd = true;
                }
            }
            else
            {
                controller.roundEnd = true;
            }
        }
        else
        {
            playerIndex = (playerIndex + 1) % players.count;
            currentPlayer = players[playerIndex];
        }
    }
    func roundComplete() -> Void
    {
        var stillIn: [Player] = [];
        for player: Player in players
        {
            (player.cards).removeAll();
            if (player.chips > 0)
            {
                player.action = "ready";
                stillIn.append(player);
            }
            else
            {
                player.action = "out";
            }
        }
        board.reset();
        deck.gather();
        if (stillIn.count >= 2)
        {
            roundState = "pre-flop";
            dealer = (dealer + 1) % players.count;
            while (!stillIn.contains(players[dealer]))
            {
                dealer = (dealer + 1) % players.count;
            }
            var dealTo: Int = (dealer + 1) % players.count;
            while ((players[dealer].cards).count < 2)
            {
                if (stillIn.contains(players[dealTo]))
                {
                    (players[dealTo].cards).append(deck.deal());
                }
                dealTo = (dealTo + 1) % players.count;
            }
            currentBet = blind;
            advanceRound();
        }
    }
    init(_ numPlayers: Int, _ buyIn: Int, _ minBet: Int, _ interface: Engagement)
    {
        controller = interface;
        board = Board();
        deck = Deck();
        blind = minBet;
        currentBet = blind;
        raiseSteps = [blind, (blind * 2), (blind * 3)];
        dealer = Int.random(in: 0 ..< numPlayers);
        if (numPlayers > 2)
        {
            playerIndex = (dealer + 3) % numPlayers;
        }
        else
        {
            playerIndex = dealer;
        }
        players = [Player(" You ", buyIn, self, true)];
        while (players.count < numPlayers)
        {
            players.append(Player("CPU-" + String(players.count),
                                  buyIn, self, false));
        }
        var dealTo: Int = (dealer + 1) % numPlayers;
        while ((players[dealer].cards).count < 2)
        {
            (players[dealTo].cards).append(deck.deal());
            dealTo = (dealTo + 1) % numPlayers;
        }
        if (numPlayers > 2)
        {
            players[dealTo].post(minBet / 2);
            dealTo = (dealTo + 1) % numPlayers;
            players[dealTo].post(minBet);
        }
        else
        {
            players[dealer].post(minBet / 2);
            players[dealTo].post(minBet);
        }
        setCurrentPlayer(players[playerIndex]);
        interface.screen = 2;
    }
}

extension Table: PlayerDataSource
{
    var inPlay: Int
    {
        var stillIn: Int = 0;
        for player: Player in players
        {
            if (player.action != "fold" && player.action != "out")
            {
                stillIn += 1;
            }
        }
        return stillIn;
    }
    var known: [Card]
    {
        return board.cards;
    }
}

protocol PlayerDataSource
{
    var inPlay: Int
    {
        get
    }
    var known: [Card]
    {
        get
    }
    var currentBet: Int
    {
        get
        set
    }
    var raiseSteps: [Int]
    {
        get
        set
    }
    func turnComplete() -> Void;
}
