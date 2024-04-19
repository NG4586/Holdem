// Nathaniel Graves
import SwiftUI

let handVals: Dictionary<String, Int> =
[
    "Royal Flush": 0,
    "Straight Flush": 1,
    "Four of a Kind": 2,
    "Full House": 3,
    "Flush": 4,
    "Straight": 5,
    "Three of a Kind": 6,
    "Two Pair": 7,
    "Pair": 8,
    "High Card": 9
];

let masks: [[Int]] = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6],
                              [1, 2], [1, 3], [1, 4], [1, 5], [1, 6],
                                      [2, 3], [2, 4], [2, 5], [2, 6],
                                              [3, 4], [3, 5], [3, 6],
                                                      [4, 5], [4, 6],
                                                              [5, 6]];

struct Card
{
    let rank: Int;
    let suit: Int;
    var revealed: Bool;
    init(_ cardID: Int, _ face: Bool)
    {
        rank = cardID / 10;
        suit = cardID % 10;
        revealed = face;
    }
}

var cardSet: [Int] =
[
    20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140,
    21, 31, 41, 51, 61, 71, 81, 91, 101, 111, 121, 131, 141,
    22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 132, 142,
    23, 33, 43, 53, 63, 73, 83, 93, 103, 113, 123, 133, 143
];

func displayCard(_ card: Card) -> some View
{
    var cardName: String = "card_0";
    if (card.revealed)
    {
        cardName = "card_" + String(card.rank) + String(card.suit);
    }
    let cardURL: URL? = Bundle.main.url(forResource: cardName, withExtension: ".jpg");
    var cardImage: NSImage? = NSImage();
    if (cardURL != nil)
    {
        cardImage = NSImage(contentsOf: (cardURL!));
    }
    return Image(nsImage: cardImage!)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 90, height: 125, alignment: .center)
      .clipped();
}

func flush(_ cards: [Card]) -> Bool
{
    return cards[0].suit == cards[1].suit
           && cards[1].suit == cards[2].suit
           && cards[2].suit == cards[3].suit
           && cards[3].suit == cards[4].suit;
}

func straight(_ sortedCards: [Card]) -> Bool
{
    if (sortedCards[3].rank == 5 && sortedCards[4].rank == 14)
    {
        return sortedCards[0].rank == 2
               && sortedCards[1].rank == 3
               && sortedCards[2].rank == 4;
    }
    return sortedCards[0].rank + 1 == sortedCards[1].rank
           && sortedCards[1].rank + 1 == sortedCards[2].rank
           && sortedCards[2].rank + 1 == sortedCards[3].rank
           && sortedCards[3].rank + 1 == sortedCards[4].rank;
}

func highCard(_ leftCard: Card, _ rightCard: Card) -> Bool
{
    return leftCard.rank < rightCard.rank;
}

struct Hand
{
    let name: String;
    let heldBy: Int;
    let value: Int;
    let ties: [Int];
    init(_ player: Int, _ five: [Card])
    {
        heldBy = player;
        let cards: [Card] = five.sorted(by: highCard);
        if (flush(cards) && straight(cards) && cards[0].rank == 10)
        {
            name = "Royal Flush";
            ties = [];
        }
        else if (flush(cards) && straight(cards) && cards[4].rank == 14)
        {
            name = "Straight Flush";
            ties = [5];
        }
        else if (flush(cards) && straight(cards))
        {
            name = "Straight Flush";
            ties = [cards[4].rank];
        }
        else if (cards[0].rank == cards[3].rank)
        {
            name = "Four of a Kind";
            ties = [cards[0].rank, cards[4].rank];
        }
        else if (cards[1].rank == cards[4].rank)
        {
            name = "Four of a Kind";
            ties = [cards[4].rank, cards[0].rank];
        }
        else if (cards[0].rank == cards[2].rank && cards[3].rank == cards[4].rank)
        {
            name = "Full House";
            ties = [cards[0].rank, cards[4].rank];
        }
        else if (cards[0].rank == cards[1].rank && cards[2].rank == cards[4].rank)
        {
            name = "Full House";
            ties = [cards[4].rank, cards[0].rank];
        }
        else if (flush(cards))
        {
            name = "Flush";
            ties = [cards[4].rank, cards[3].rank, cards[2].rank, cards[1].rank, cards[0].rank];
        }
        else if (straight(cards) && cards[0].rank == 2 && cards[4].rank == 14)
        {
            name = "Straight";
            ties = [5];
        }
        else if (straight(cards))
        {
            name = "Straight";
            ties = [cards[4].rank];
        }
        else if (cards[0].rank == cards[2].rank)
        {
            name = "Three of a Kind";
            ties = [cards[2].rank, cards[4].rank, cards[3].rank];
        }
        else if (cards[1].rank == cards[3].rank)
        {
            name = "Three of a Kind";
            ties = [cards[2].rank, cards[4].rank, cards[0].rank];
        }
        else if (cards[2].rank == cards[4].rank)
        {
            name = "Three of a Kind";
            ties = [cards[2].rank, cards[1].rank, cards[0].rank];
        }
        else if (cards[0].rank == cards[1].rank && cards[2].rank == cards[3].rank)
        {
            name = "Two Pair";
            ties = [cards[3].rank, cards[1].rank, cards[4].rank];
        }
        else if (cards[0].rank == cards[1].rank && cards[3].rank == cards[4].rank)
        {
            name = "Two Pair";
            ties = [cards[3].rank, cards[1].rank, cards[2].rank];
        }
        else if (cards[1].rank == cards[2].rank && cards[3].rank == cards[4].rank)
        {
            name = "Two Pair";
            ties = [cards[3].rank, cards[1].rank, cards[0].rank];
        }
        else if (cards[0].rank == cards[1].rank)
        {
            name = "Pair";
            ties = [cards[0].rank, cards[4].rank, cards[3].rank, cards[2].rank];
        }
        else if (cards[1].rank == cards[2].rank)
        {
            name = "Pair";
            ties = [cards[1].rank, cards[4].rank, cards[3].rank, cards[0].rank];
        }
        else if (cards[2].rank == cards[3].rank)
        {
            name = "Pair";
            ties = [cards[2].rank, cards[4].rank, cards[2].rank, cards[0].rank];
        }
        else if (cards[3].rank == cards[4].rank)
        {
            name = "Pair";
            ties = [cards[3].rank, cards[2].rank, cards[1].rank, cards[0].rank];
        }
        else
        {
            name = "High Card";
            ties = [cards[4].rank, cards[3].rank, cards[2].rank, cards[1].rank, cards[0].rank];
        }
        value = (handVals[name]!);
    }
}

func evalHand(_ leftHand: Hand, _ rightHand: Hand) -> Int
{
    if (leftHand.value < rightHand.value)
    {
        return -1;
    }
    if (leftHand.value > rightHand.value)
    {
        return 1;
    }
    var index: Int = 0;
    while (index < (leftHand.ties).count)
    {
        if (leftHand.ties[index] < rightHand.ties[index])
        {
            return 1;
        }
        if (leftHand.ties[index] > rightHand.ties[index])
        {
            return -1;
        }
        index += 1;
    }
    return 0;
}

func betterHand(_ leftHand: Hand, _ rightHand: Hand) -> Bool
{
    return (evalHand(leftHand, rightHand) <= 0);
}

func handidates() -> [Hand]
{
    var playerAt: Int = 0;
    var nextHand: [Card];
    var allHands: [Hand] = [];
    while (playerAt < (currentGame.players).count)
    {
        if (!(currentGame.players[playerAt].folded))
        {
            for mask in masks
            {
                nextHand = [];
                if (mask[0] != 0)
                {
                    nextHand.append(currentGame.players[playerAt].hand[0]);
                }
                if (mask[0] != 1 && mask[1] != 1)
                {
                    nextHand.append(currentGame.players[playerAt].hand[1]);
                }
                if (mask[0] != 2 && mask[1] != 2)
                {
                    nextHand.append(currentGame.board[0]);
                }
                if (mask[0] != 3 && mask[1] != 3)
                {
                    nextHand.append(currentGame.board[1]);
                }
                if (mask[1] != 4 && mask[0] != 4)
                {
                    nextHand.append(currentGame.board[2]);
                }
                if (mask[1] != 5 && mask[0] != 5)
                {
                    nextHand.append(currentGame.board[3]);
                }
                if (mask[1] != 6)
                {
                    nextHand.append(currentGame.board[4]);
                }
                allHands.append(Hand(playerAt, nextHand));
            }
        }
        playerAt += 1;
    }
    return allHands;
}

func bestHand(_ many: [Hand]) -> [Int]
{
    let hands: [Hand] = many.sorted(by: betterHand);
    var highest: [Int] = [];
    for hand: Hand in hands
    {
        if (evalHand(hands[0], hand) == 0)
        {
            highest.append(hand.heldBy);
            continue;
        }
        break;
    }
    return highest;
}
