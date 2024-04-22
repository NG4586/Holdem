// Nathaniel Graves
import Foundation

class Board
{
    var cards: [Card];
    func reset() -> Void
    {
        cards.removeAll();
    }
    func flop(_ deck: Deck) -> Void
    {
        deck.burn();
        cards.append(deck.flip());
        cards.append(deck.flip());
        cards.append(deck.flip());
    }
    func turn(_ deck: Deck) -> Void
    {
        deck.burn();
        cards.append(deck.flip());
    }
    func river(_ deck: Deck) -> Void
    {
        deck.burn();
        cards.append(deck.flip());
    }
    init()
    {
        cards = [];
    }
}
