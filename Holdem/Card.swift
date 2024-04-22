// Nathaniel Graves
import SwiftUI

struct Card: Identifiable
{
    let id: UUID = UUID();
    let rank: Int;
    let suit: Int;
    var image: NSImage?;
    var file: URL?
    {
        didSet
        {
            if (file != nil)
            {
                image = NSImage(contentsOf: file!);
            }
            else
            {
                image = NSImage();
            }
        }
    }
    var name: String
    {
        didSet
        {
            file = Bundle.main.url(forResource: name, withExtension: ".jpg");
        }
    }
    var revealed: Bool
    {
        didSet
        {
            name = "card_" + String(rank) + String(suit);
        }
    }
    mutating func reveal() -> Void
    {
        revealed = true;
    }
    init(_ cardID: Int, _ faceUp: Bool)
    {
        rank = cardID / 10;
        suit = cardID % 10;
        if (faceUp)
        {
            name = "card_" + String(rank) + String(suit);
            revealed = true;
        }
        else
        {
            name = "card_0";
            revealed = false;
        }
    }
}

extension Card: Comparable
{
    static func < (_ leftCard: Card, _ rightCard: Card) -> Bool
    {
        return leftCard.rank < rightCard.rank;
    }
    static func == (_ leftCard: Card, _ rightCard: Card) -> Bool
    {
        return leftCard.rank == rightCard.rank;
    }
}
