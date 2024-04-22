// Nathaniel Graves
import Foundation

class Hand
{
    let cards: [Card];
    var type: String;
    let handSize: Int = 5;
    func classify() -> String
    {
        var straight: Bool = true;
        var suited: Bool = true;
        var cardAt: Int = 1;
        while (cardAt < handSize)
        {
            if (cards[cardAt].rank != cards[cardAt - 1].rank + 1 &&
                  !(cards[cardAt].rank == 14 && cards[cardAt - 1].rank == 5))
            {
                straight = false;
            }
            if (cards[cardAt].suit != cards[0].suit)
            {
                suited = false;
            }
            cardAt += 1;
        }
        if (straight && suited)
        {
            if (cards[0].rank == 10)
            {
                return "Royal Flush";
            }
            return "Straight Flush";
        }
        if (suited)
        {
            return "Flush";
        }
        if (straight)
        {
            return "Straight";
        }
        var unmatched: Int = 0;
        if (cards[0] != cards[1])
        {
            unmatched += 1;
        }
        cardAt = 1;
        while (cardAt < handSize - 1)
        {
            if (cards[cardAt] != cards[cardAt - 1] &&
                  cards[cardAt] != cards[cardAt + 1])
            {
                unmatched += 1;
            }
            cardAt += 1;
        }
        if (cards[handSize - 1] != cards[handSize - 2])
        {
            unmatched += 1;
        }
        if (unmatched == 0)
        {
            return "Full House";
        }
        if (unmatched == 1)
        {
            if (cards[0] == cards[3] || cards[1] == cards[4])
            {
                return "Four of a Kind";
            }
            return "Two Pair";
        }
        if (unmatched == 2)
        {
            return "Three of a Kind";
        }
        if (unmatched == 3)
        {
            return "Pair";
        }
        return "High Card";
    }
    init(_ five: [Card])
    {
        cards = five.sorted();
        type = "pending";
        type = classify();
    }
}

extension Hand: Comparable
{
    static func < (_ leftHand: Hand, _ rightHand: Hand) -> Bool
    {
        if (rightHand.type == "Royal Flush")
        {
            return true;
        }
        if (leftHand.type == "Royal Flush")
        {
            return false;
        }
        if (rightHand.type == "Straight Flush")
        {
            if (leftHand.type == "Straight Flush")
            {
                if ((leftHand.cards)[4].rank == 14)
                {
                    return true;
                }
                if ((rightHand.cards)[4].rank == 14)
                {
                    return false;
                }
                return (leftHand.cards)[4] < (rightHand.cards)[4];
            }
            return true;
        }
        if (leftHand.type == "Straight Flush")
        {
            return false;
        }
        if (rightHand.type == "Four of a Kind")
        {
            if (leftHand.type == "Four of a Kind")
            {
                if ((leftHand.cards)[2] == (rightHand.cards)[2])
                {
                    if ((leftHand.cards)[0] == (leftHand.cards)[2])
                    {
                        if ((rightHand.cards)[0] == (rightHand.cards)[2])
                        {
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[4] < (rightHand.cards)[0];
                    }
                    if ((rightHand.cards)[0] == (rightHand.cards)[2])
                    {
                        return (leftHand.cards)[0] < (rightHand.cards)[4];
                    }
                    return (leftHand.cards)[0] < (rightHand.cards)[0];
                }
                return (leftHand.cards)[2] < (rightHand.cards)[2];
            }
            return true;
        }
        if (leftHand.type == "Four of a Kind")
        {
            return false;
        }
        if (rightHand.type == "Full House")
        {
            if (leftHand.type == "Full House")
            {
                if ((leftHand.cards)[2] == (rightHand.cards)[2])
                {
                    if ((leftHand.cards)[0] == (leftHand.cards)[2])
                    {
                        if ((rightHand.cards)[0] == (rightHand.cards)[2])
                        {
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[4] < (rightHand.cards)[0];
                    }
                    if ((rightHand.cards)[0] == (rightHand.cards)[2])
                    {
                        return (leftHand.cards)[0] < (rightHand.cards)[4];
                    }
                    return (leftHand.cards)[0] < (rightHand.cards)[0];
                }
                return (leftHand.cards)[2] < (rightHand.cards)[2];
            }
            return true;
        }
        if (leftHand.type == "Full House")
        {
            return false;
        }
        if (rightHand.type == "Flush")
        {
            if (leftHand.type == "Flush")
            {
                if ((leftHand.cards)[4] == (rightHand.cards)[4])
                {
                    if ((leftHand.cards)[3] == (rightHand.cards)[3])
                    {
                        if ((leftHand.cards)[2] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[1] == (rightHand.cards)[1])
                            {
                                return (leftHand.cards)[0] < (rightHand.cards)[0];
                            }
                            return (leftHand.cards)[1] < (rightHand.cards)[1];
                        }
                        return (leftHand.cards)[2] < (rightHand.cards)[2];
                    }
                    return (leftHand.cards)[3] < (rightHand.cards)[3];
                }
                return (leftHand.cards)[4] < (rightHand.cards)[4];
            }
            return true;
        }
        if (leftHand.type == "Flush")
        {
            return false;
        }
        if (rightHand.type == "Straight")
        {
            if (leftHand.type == "Straight")
            {
                if ((leftHand.cards)[4].rank == 14)
                {
                    return true;
                }
                if ((rightHand.cards)[4].rank == 14)
                {
                    return false;
                }
                return (leftHand.cards)[4] < (rightHand.cards)[4];
            }
            return true;
        }
        if (leftHand.type == "Straight")
        {
            return false;
        }
        if (rightHand.type == "Three of a Kind")
        {
            if (leftHand.type == "Three of a Kind")
            {
                if ((leftHand.cards)[2] == (rightHand.cards)[2])
                {
                    if ((leftHand.cards)[0] == (leftHand.cards)[2])
                    {
                        if ((rightHand.cards)[0] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return (leftHand.cards)[3] < (rightHand.cards)[3];
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        if ((rightHand.cards)[1] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return false;
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return false;
                    }
                    if ((leftHand.cards)[1] == (leftHand.cards)[2])
                    {
                        if ((rightHand.cards)[0] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return true;
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        if ((rightHand.cards)[1] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return (leftHand.cards)[0] < (rightHand.cards)[0];
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return false;
                    }
                    if ((rightHand.cards)[1] == (rightHand.cards)[2])
                    {
                        return true;
                    }
                    if ((leftHand.cards)[1] == (rightHand.cards[1]))
                    {
                        return (leftHand.cards)[0] < (rightHand.cards)[0];
                    }
                    return (leftHand.cards)[1] < (rightHand.cards)[1];
                }
                return (leftHand.cards)[2] < (rightHand.cards)[2];
            }
            return true;
        }
        if (leftHand.type == "Three of a Kind")
        {
            return false;
        }
        if (rightHand.type == "Two Pair")
        {
            if (leftHand.type == "Two Pair")
            {
                if ((leftHand.cards)[3] == (rightHand.cards)[3])
                {
                    if ((leftHand.cards)[1] == (rightHand.cards)[1])
                    {
                        if ((leftHand.cards)[2] == (leftHand.cards)[3])
                        {
                            if ((rightHand.cards)[2] == (rightHand.cards)[3])
                            {
                                return (leftHand.cards)[4] < (rightHand.cards)[4];
                            }
                            return false;
                        }
                        if ((leftHand.cards)[0] == (leftHand.cards)[1])
                        {
                            if ((rightHand.cards)[2] == (rightHand.cards)[3])
                            {
                                return true;
                            }
                            if ((rightHand.cards)[0] == (rightHand.cards)[1])
                            {
                                return (leftHand.cards)[2] < (rightHand.cards)[2];
                            }
                            return false;
                        }
                        if ((rightHand.cards)[0] == (rightHand.cards)[1])
                        {
                            return true;
                        }
                        return (leftHand.cards)[0] < (rightHand.cards)[0];
                    }
                    return (leftHand.cards)[1] < (rightHand.cards)[1];
                }
                return (leftHand.cards)[3] < (rightHand.cards)[3];
            }
            return true;
        }
        if (leftHand.type == "Two Pair")
        {
            return false;
        }
        if (rightHand.type == "Pair")
        {
            if (leftHand.type == "Pair")
            {
                if ((leftHand.cards)[0] == (leftHand.cards)[1])
                {
                    if ((rightHand.cards)[0] == (rightHand.cards)[1])
                    {
                        if ((leftHand.cards)[0] == (rightHand.cards)[0])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                if ((leftHand.cards)[3] == (rightHand.cards)[3])
                                {
                                    return (leftHand.cards)[2] < (rightHand.cards)[2];
                                }
                                return (leftHand.cards)[3] < (rightHand.cards)[3];
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[0] < (rightHand.cards)[0];
                    }
                    if ((rightHand.cards)[1] == (rightHand.cards)[2])
                    {
                        if ((leftHand.cards)[0] == (rightHand.cards)[1])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                if ((leftHand.cards)[3] == (rightHand.cards)[3])
                                {
                                    return false;
                                }
                                return (leftHand.cards)[3] < (rightHand.cards)[3];
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[0] < (rightHand.cards)[1];
                    }
                    if ((rightHand.cards)[2] == (rightHand.cards)[3])
                    {
                        if ((leftHand.cards)[0] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return false;
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[0] < (rightHand.cards)[2];
                    }
                    if ((leftHand.cards)[0] == (rightHand.cards)[3])
                    {
                        return false;
                    }
                    return (leftHand.cards)[0] < (rightHand.cards)[3];
                }
                if ((leftHand.cards)[1] == (leftHand.cards)[2])
                {
                    if ((rightHand.cards)[0] == (rightHand.cards)[1])
                    {
                        if ((leftHand.cards)[1] == (rightHand.cards)[0])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                if ((leftHand.cards)[3] == (rightHand.cards)[3])
                                {
                                    return true;
                                }
                                return (leftHand.cards)[3] < (rightHand.cards)[3];
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[1] < (rightHand.cards)[0];
                    }
                    if ((rightHand.cards)[1] == (rightHand.cards)[2])
                    {
                        if ((leftHand.cards)[1] == (rightHand.cards)[1])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                if ((leftHand.cards)[3] == (rightHand.cards)[3])
                                {
                                    return (leftHand.cards)[0] < (rightHand.cards)[0];
                                }
                                return (leftHand.cards)[3] < (rightHand.cards)[3];
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[1] < (rightHand.cards)[1];
                    }
                    if ((rightHand.cards)[2] == (rightHand.cards)[3])
                    {
                        if ((leftHand.cards)[1] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return false;
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[1] < (rightHand.cards)[2];
                    }
                    if ((leftHand.cards)[1] == (rightHand.cards)[3])
                    {
                        return false;
                    }
                    return (leftHand.cards)[1] < (rightHand.cards)[3];
                }
                if ((leftHand.cards)[2] == (leftHand.cards)[3])
                {
                    if ((rightHand.cards)[0] == (rightHand.cards)[1])
                    {
                        if ((leftHand.cards)[2] == (rightHand.cards)[0])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return true;
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[2] < (rightHand.cards)[0];
                    }
                    if ((rightHand.cards)[1] == (rightHand.cards)[2])
                    {
                        if ((leftHand.cards)[2] == (rightHand.cards)[1])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                return true;
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[2] < (rightHand.cards)[1];
                    }
                    if ((rightHand.cards)[2] == (rightHand.cards)[3])
                    {
                        if ((leftHand.cards)[2] == (rightHand.cards)[2])
                        {
                            if ((leftHand.cards)[4] == (rightHand.cards)[4])
                            {
                                if ((leftHand.cards)[1] == (rightHand.cards)[1])
                                {
                                    return (leftHand.cards)[0] < (rightHand.cards)[0];
                                }
                                return (leftHand.cards)[1] < (rightHand.cards)[1];
                            }
                            return (leftHand.cards)[4] < (rightHand.cards)[4];
                        }
                        return (leftHand.cards)[2] < (rightHand.cards)[2];
                    }
                    if ((leftHand.cards)[2] == (rightHand.cards)[3])
                    {
                        return false;
                    }
                    return (leftHand.cards)[2] < (rightHand.cards)[3];
                }
                if ((rightHand.cards)[0] == (rightHand.cards)[1])
                {
                    if ((leftHand.cards)[3] == (rightHand.cards)[0])
                    {
                        return true;
                    }
                    return (leftHand.cards)[3] < (rightHand.cards)[0];
                }
                if ((rightHand.cards)[1] == (rightHand.cards)[2])
                {
                    if ((leftHand.cards)[3] == (rightHand.cards)[1])
                    {
                        return true;
                    }
                    return (leftHand.cards)[3] < (rightHand.cards)[1];
                }
                if ((rightHand.cards)[2] == (rightHand.cards)[3])
                {
                    if ((leftHand.cards)[3] == (rightHand.cards)[2])
                    {
                        return true;
                    }
                    return (leftHand.cards)[3] < (rightHand.cards)[2];
                }
                if ((leftHand.cards)[3] == (rightHand.cards)[3])
                {
                    if ((leftHand.cards)[2] == (rightHand.cards)[2])
                    {
                        if ((leftHand.cards)[1] == (rightHand.cards)[1])
                        {
                            return (leftHand.cards)[0] < (rightHand.cards)[0];
                        }
                        return (leftHand.cards)[1] < (rightHand.cards)[1];
                    }
                    return (leftHand.cards)[2] < (rightHand.cards)[2];
                }
                return (leftHand.cards)[3] < (rightHand.cards)[3];
            }
            return true;
        }
        if (leftHand.type == "Pair")
        {
            return false;
        }
        if ((leftHand.cards)[4] == (rightHand.cards)[4])
        {
            if ((leftHand.cards)[3] == (rightHand.cards)[3])
            {
                if ((leftHand.cards)[2] == (rightHand.cards)[2])
                {
                    if ((leftHand.cards)[1] == (rightHand.cards)[1])
                    {
                        return (leftHand.cards)[0] < (rightHand.cards)[0];
                    }
                    return (leftHand.cards)[1] < (rightHand.cards)[1];
                }
                return (leftHand.cards)[2] < (rightHand.cards)[2];
            }
            return (leftHand.cards)[3] < (rightHand.cards)[3];
        }
        return (leftHand.cards)[4] < (rightHand.cards)[4];
    }
    static func == (_ leftHand: Hand, _ rightHand: Hand) -> Bool
    {
        if (leftHand.type == rightHand.type)
        {
            if ((leftHand.cards)[4] == (rightHand.cards)[4])
            {
                if ((leftHand.cards)[3] == (rightHand.cards)[3])
                {
                    if ((leftHand.cards)[2] == (rightHand.cards)[2])
                    {
                        if ((leftHand.cards)[1] == (rightHand.cards)[1])
                        {
                            if ((leftHand.cards)[0] == (rightHand.cards)[0])
                            {
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }
}
