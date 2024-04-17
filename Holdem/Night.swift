// Nathaniel Graves
import SwiftUI

var controller: Engagement = Engagement.shared;

func newGame() -> Void
{
    var gameSettings: GameInfo = GameInfo();
    var startingPlayers: [Player] = [];
    var playerAt: Int = 0;
    while (playerAt < controller.numPlayers)
    {
        startingPlayers.append(Player(playerNames[playerAt], controller.buyIn));
        playerAt += 1;
    }
    gameSettings.players = startingPlayers;
    gameSettings.roundLimit = controller.numRounds;
    gameSettings.currentRound = 0;
    gameSettings.smallBlind = controller.blind / 2;
    gameSettings.bigBlind = controller.blind;
    gameSettings.dealer = Int.random(in: 0 ..< controller.numPlayers);
    currentGame = gameSettings;
    controller.screen = 2;
    gameRound();
}

func openMenu() -> Void
{
    controller.screen = 1;
}

func closeMenu() -> Void
{
    controller.screen = 0;
}
