// Nathaniel Graves
import SwiftUI

var controller: Engagement = Engagement.shared;

func storeOptions() -> Void
{
    let involvement = UserDefaults.standard;
    involvement.set(controller.numPlayers, forKey: "numPlayers");
    involvement.set(controller.numRounds, forKey: "numRounds");
    involvement.set(controller.buyIn, forKey: "buyIn");
    involvement.set(controller.blind, forKey: "blind");
}

func retrieveOptions() -> Void
{
    let attainment = UserDefaults.standard;
    let setPlayers = attainment.integer(forKey: "numPlayers");
    let setRounds = attainment.integer(forKey: "numRounds");
    let setBuyin = attainment.integer(forKey: "buyIn");
    let setBlind = attainment.integer(forKey: "blind");
    if (setPlayers > 0) // 0: user never set this value
    {
        controller.numPlayers = setPlayers;
    }
    if (setRounds > 0)
    {
        controller.numPlayers = setRounds;
    }
    if (setBuyin > 0)
    {
        controller.numPlayers = setBuyin;
    }
    if (setBlind > 0)
    {
        controller.numPlayers = setBlind;
    }
}

func newGame() -> Void
{
    retrieveOptions();
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
    retrieveOptions();
    controller.screen = 1;
}

func closeMenu() -> Void
{
    storeOptions();
    controller.screen = 0;
}
