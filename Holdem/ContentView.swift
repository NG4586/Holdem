// Nathaniel Graves
import SwiftUI

class Engagement: ObservableObject
{
    static let shared: Engagement = Engagement();
    @Published var screen: Int = 0;
    @Published var numPlayers: Int = 2;
    @Published var numRounds: Int = 10;
    @Published var round_tag: String = ""
    {
        didSet
        {
            let entry: Int? = Int(round_tag);
            if (entry != nil)
            {
                numRounds = (entry!);
            }
        }
    }
    @Published var buyIn: Int = 100;
    @Published var buyin_tag: String = ""
    {
        didSet
        {
            let entry: Int? = Int(buyin_tag);
            if (entry != nil)
            {
                buyIn = (entry!);
            }
        }
    }
    @Published var blind: Int = 5;
    @Published var blind_tag: String = ""
    {
        didSet
        {
            let entry: Int? = Int(blind_tag);
            if (entry != nil)
            {
                blind = (entry!);
            }
        }
    }
}

struct ContentView: View
{
    @ObservedObject var interface: Engagement = Engagement.shared;
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
                    TextField(text: $interface.round_tag)
                    {
                        Text("Number of rounds:");
                    }
                    TextField(text: $interface.buyin_tag)
                    {
                        Text("Starting chips per player:");
                    }
                    TextField(text: $interface.blind_tag)
                    {
                        Text("Big blind:");
                    }
                    Text("Small blind: " + String(interface.blind / 2));
                }
                Button("Confirm", action: closeMenu);
            }
            else
            {
                if (currentGame.board.count == 5)
                {
                    HStack
                    {
                        if ((currentGame.board)[0].revealed)
                        {
                            Image(displayCard((currentGame.board)[0]));
                            if ((currentGame.board)[1].revealed)
                            {
                                Image(displayCard((currentGame.board)[1]));
                                if ((currentGame.board)[2].revealed)
                                {
                                    Image(displayCard((currentGame.board)[2]));
                                    if ((currentGame.board)[3].revealed)
                                    {
                                        Image(displayCard((currentGame.board)[3]));
                                        if ((currentGame.board)[4].revealed)
                                        {
                                            Image(displayCard((currentGame.board)[4]));
                                        }
                                    }
                                }
                            }
                        }
                    }
                    ForEach(currentGame.players)
                    {
                        player in HStack
                        {
                            Text(player.id);
                            if ((player.hand).count == 2)
                            {
                                Image(displayCard(player.hand[0]));
                                Image(displayCard(player.hand[1]));
                            }
                            Text("Chips: " + String(player.chips));
                        }
                    }
                    Button("Continue", action: gameRound);
                }
            }
        }
        .padding();
    }
}
