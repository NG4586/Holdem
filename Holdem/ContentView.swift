// Nathaniel Graves
import SwiftUI

class Engagement: ObservableObject
{
    static let shared: Engagement = Engagement();
    @Published var screen: Int = 0;
    @Published var numPlayers: Int = 2;
    @Published var numRounds: Int = 10;
    @Published var buyIn: Int = 100;
    @Published var blind: Int = 5;
}

struct ContentView: View
{
    var body: some View
    {
        VStack
        {
            if (interface.screen == 0)
            {
                Button("New Game", action: newGame);
                Button("Options", action: openMenu);
            }
            else if (interface.screen == 1)
            {
                Form
                {
                    Picker(selection: $interface.numPlayers, label: Text("Number of players:"))
                    {
                        Text("2").tag(2);
                        Text("3").tag(3);
                        Text("4").tag(4);
                        Text("5").tag(5);
                        Text("6").tag(6);
                        Text("7").tag(7);
                        Text("8").tag(8);
                    }
                      .pickerStyle(.radioGroup)
                      .horizontalRadioGroupLayout();
                    TextField(text: $interface.numRounds)
                    {
                        Text("Number of rounds:");
                    }
                    TextField(text: $interface.buyIn)
                    {
                        Text("Starting chips per player:");
                    }
                    TextField(text: $interface.blind)
                    {
                        Text("Big blind:");
                    }
                    Text("Small blind: " + String(blind / 2));
                }
                Button("Confirm", action: closeMenu);
            }
            else
            {
                if (currentGame.board.count == 5)
                {
                    HStack
                    {
                        for card: Card in currentGame.board
                        {
                            if (card.revealed)
                            {
                                Image(displayCard(card));
                            }
                        }
                    }
                    ForEach(currentGame.players)
                    {
                        $player in HStack
                        {
                            if ((player.hand).count == 2)
                            {
                                Image(displayCard(player.hand[0]));
                                Image(displayCard(player.hand[1]));
                            }
                            Text("Chips: " + $player.chips);
                        }
                    }
                    Button("Continue", action: gameRound);
                }
            }
        }
        .padding();
    }
}
