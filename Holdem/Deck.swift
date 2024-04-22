// Nathaniel Graves
import Foundation

class Deck
{
    let tags: [Int] = [20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140,
                       21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 131, 141,
                       22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 132, 142,
                       23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 133, 143];
    var undealt: [Card] = [];
    func gather() -> Void
    {
        undealt.removeAll();
        for tag in tags
        {
            undealt.append(Card(tag, false));
        }
        undealt.shuffle();
    }
    func burn() -> Void
    {
        undealt.removeFirst();
    }
    func deal() -> Card
    {
        return undealt.removeFirst();
    }
    func flip() -> Card
    {
        undealt[0].reveal();
        return undealt.removeFirst();
    }
    init()
    {
        gather();
    }
}
