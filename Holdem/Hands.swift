// Nathaniel Graves
import Foundation

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

func flush(_ cards: [Card])
{
    return cards[0].suit == cards[1].suit
           && cards[1].suit == cards[2].suit
           && cards[2].suit == cards[3].suit
           && cards[3].suit == cards[4].suit;
}

func straight(_ sortedCards: [Card])
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

struct Hand
{
    let name: String;
    let heldBy: Int;
    let value: Int;
    let ties: [Int];
    init(_ player: Int, _ cards: [Card])
    {
        heldBy = player;
        cards.sort(by: $0.rank < $1.rank);
        if (flush(cards) && straight(cards) && cards[0] == 10)
        {
            name = "Royal Flush";
            ties = [];
        }
        else if (flush(cards) && straight(cards) && cards[4] == 14)
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
        else if (straight(cards) && cards[0] == 2 && cards[4] == 14)
        {
            name = "Straight";
            ties = 5;
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
        return 1;
    }
    if (leftHand.value > rightHand.value)
    {
        return -1;
    }
    var index: Int = 0;
    while (index < (leftHand.ties).count)
    {
        if (leftHand.ties[index] < rightHand.ties[index])
        {
            return -1;
        }
        if (leftHand.ties[index] > rightHand.ties[index])
        {
            return 1;
        }
        index += 1;
    }
    return 0;
}

func betterHand(_ leftHand: Hand, _ rightHand: Hand) -> Bool
{
    return (evalHand(leftHand, rightHand) <= 0);
}

func bestHand(_ hands: [Hand]) -> [Int]
{
    hands.sort(by: betterHand);
    var highest: [Int] = [];
    for hand: Hand in hands
    {
        if (evalHand(hands[0], hand) == 0)
        {
            highest.append(hand.player);
            continue;
        }
        break;
    }
    return highest;
}
