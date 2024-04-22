// Nathaniel Graves
import SwiftUI

func storeOptions(_ controller: Engagement) -> Void
{
    let involvement: UserDefaults = UserDefaults.standard;
    involvement.set(controller.numPlayers, forKey: "numPlayers");
    //involvement.set(controller.numRounds, forKey: "numRounds");
    involvement.set(controller.buyIn, forKey: "buyIn");
    involvement.set(controller.blind, forKey: "blind");
}

func retrieveOptions(_ controller: Engagement) -> Void
{
    let attainment: UserDefaults = UserDefaults.standard;
    let setPlayers = attainment.integer(forKey: "numPlayers");
    //let setRounds = attainment.integer(forKey: "numRounds");
    let setBuyin = attainment.integer(forKey: "buyIn");
    let setBlind = attainment.integer(forKey: "blind");
    if (setPlayers > 0)
    {
        controller.numPlayers = setPlayers;
    }
    /*if (setRounds > 0)
    {
        controller.numRounds = setRounds;
    }*/
    if (setBuyin > 0)
    {
        controller.buyIn = setBuyin;
    }
    if (setBlind > 0)
    {
        controller.blind = setBlind;
    }
}

func newGame(_ controller: Engagement) -> Void
{
    retrieveOptions(controller);
    controller.table = Table(controller.numPlayers, controller.buyIn, controller.blind, controller);
}

func openMenu(_ controller: Engagement) -> Void
{
    retrieveOptions(controller);
    controller.screen = 1;
}

func closeMenu(_ controller: Engagement) -> Void
{
    storeOptions(controller);
    controller.screen = 0;
}
