// Nathaniel Graves
import Foundation

struct Option: Identifiable
{
    let id: UUID = UUID();
    let name: String;
    init(_ option: String)
    {
        name = option;
    }
}

class Player: Identifiable
{
    let id: UUID = UUID();
    let name: String;
    var cards: [Card]
    {
        didSet
        {
            if (user && cards.count == 2)
            {
                cards[0].reveal();
                cards[1].reveal();
            }
        }
    }
    let masks: [[Int]] = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6],
                                  [1, 2], [1, 3], [1, 4], [1, 5], [1, 6],
                                          [2, 3], [2, 4], [2, 5], [2, 6],
                                                  [3, 4], [3, 5], [3, 6],
                                                          [4, 5], [4, 6],
                                                                  [5, 6]];
    func bestHand() -> Hand
    {
        let cardSet: [Card] = [cards[0], cards[1], dataSource.known[0],
                               dataSource.known[1], dataSource.known[2],
                               dataSource.known[3], dataSource.known[4]];
        var handidates: [Hand] = [];
        var nextHand: [Card];
        var cardPos: Int;
        for mask: [Int] in masks
        {
            nextHand = [];
            cardPos = 0;
            while (cardPos < cardSet.count)
            {
                if (cardPos != mask[0] && cardPos != mask[1])
                {
                    nextHand.append(cardSet[cardPos]);
                }
                cardPos += 1;
            }
            handidates.append(Hand(nextHand));
        }
        return (handidates.max()!);
    }
    var chips: Int;
    var posted: Int;
    func post(_ amount: Int) -> Void
    {
        if (amount > dataSource.currentBet)
        {
            dataSource.currentBet = amount;
        }
        let deficit: Int = amount - posted;
        if (deficit > chips)
        {
            posted += chips;
            chips = 0;
        }
        else
        {
            posted += deficit;
            chips -= deficit;
        }
    }
    var dataSource: PlayerDataSource;
    let user: Bool;
    var userOptions: [Option];
    func decision(_ options: [Option]) -> String // todo: make smarter
    {
        for option: Option in options
        {
            if (option.name == "check")
            {
                return "check";
            }
        }
        return "call";
    }
    var action: String = "ready"
    {
        didSet
        {
            if (action == "pending")
            {
                var options: [Option] = [Option("fold")];
                if (posted == dataSource.currentBet)
                {
                    options.append(Option("check"));
                }
                else
                {
                    options.append(Option("call"));
                }
                if (!((dataSource.raiseSteps).isEmpty))
                {
                    options.append(Option("raise"));
                }
                if (user)
                {
                    userOptions = options;
                }
                else
                {
                    let choice: String = decision(options);
                    if (choice == "raise")
                    {
                        post(dataSource.raiseSteps[0]);
                        dataSource.currentBet = dataSource.raiseSteps[0];
                        (dataSource.raiseSteps).removeFirst();
                    }
                    else if (choice != "fold")
                    {
                        post(dataSource.currentBet);
                    }
                    action = choice;
                    print(name, "has chosen to", action);
                    dataSource.turnComplete();
                }
            }
            else if (action != "ready" && action != "out")
            {
                print(name, "has chosen to", action);
                dataSource.turnComplete();
            }
        }
    }
    init(_ playerName: String, _ startingChips: Int,
         _ sourceData: PlayerDataSource, _ one: Bool)
    {
        name = playerName;
        cards = [];
        chips = startingChips;
        posted = 0;
        dataSource = sourceData;
        user = one;
        userOptions = [];
    }
}

extension Player: Hashable
{
    static func == (_ leftPlayer: Player, _ rightPlayer: Player) -> Bool
    {
        return leftPlayer.id == rightPlayer.id;
    }
    func hash(into hasher: inout Hasher)
    {
        hasher.combine(id);
    }
}
