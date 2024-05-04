// Nathaniel Graves
import SwiftUI

class Engagement: ObservableObject
{
    static let shared: Engagement = Engagement();
    @Published var screen: Int = 0;
    @Published var numPlayers: Int = 2;
    @Published var buyIn: Int = 100;
    @Published var buyin_tag: String = ""
    {
        didSet
        {
            let entry: Int? = Int(buyin_tag);
            if (entry != nil && (entry!) > 0)
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
            if (entry != nil && (entry!) > 0)
            {
                blind = (entry!);
            }
        }
    }
    @Published var table: Table? = nil;
    @Published var yourTurn: Bool = false;
    @Published var roundEnd: Bool = false;
}

struct BoardView: View
{
    @StateObject var interface: Engagement = Engagement.shared;
    var body: some View
    {
        HStack
        {
            ForEach(((interface.table!).board).cards)
            {
                card in Image(nsImage: (card.image!))
                       .resizable()
                       .aspectRatio(contentMode: .fill)
                       .frame(width: 96, height: 136, alignment: .center);
            }
        }
    }
}

struct PlayerView: View
{
    @StateObject var interface: Engagement = Engagement.shared;
    let descFont: Font = Font
                         .system(size: 14)
                         .monospaced();
    var body: some View
    {
        ScrollView
        {
            ForEach((interface.table!).players)
            {
                player in HStack
                {
                    Text(player.name).font(descFont)
                    ForEach(player.cards)
                    {
                        card in Image(nsImage: (card.image!))
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                               .frame(width: 96, height: 136, alignment: .center);
                    }
                    if (player.chips < 10)
                    {
                        Text("Chips:   " + String(player.chips)).font(descFont);
                    }
                    else if (player.chips < 100)
                    {
                        Text("Chips:  " + String(player.chips)).font(descFont);
                    }
                    else
                    {
                        Text("Chips: " + String(player.chips)).font(descFont);
                    }
                    if (player.posted < 10)
                    {
                        Text("Posted:   " + String(player.posted) + "  ").font(descFont);
                    }
                    else if (player.posted < 100)
                    {
                        Text("Posted:  " + String(player.posted) + "  ").font(descFont);
                    }
                    else
                    {
                        Text("Posted: " + String(player.posted) + "  ").font(descFont);
                    }
                }
            }
        }
    }
}

struct ContentView: View
{
    @StateObject var interface: Engagement = Engagement.shared;
    let tableSurface: LinearGradient = LinearGradient(
        colors: [Color.green, Color.purple],
        startPoint: .top,
        endPoint: .bottom
    );
    var body: some View
    {
        ZStack
        {
            tableSurface;
            VStack
            {
                if (interface.screen == 0)
                {
                    Button("New Game")
                    {
                        newGame(interface)
                    }
                    Button("Options")
                    {
                        openMenu(interface);
                    }
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
                    Button("Confirm")
                    {
                        closeMenu(interface);
                    }
                }
                else
                {
                    BoardView();
                    Divider();
                    PlayerView();
                    Divider();
                    if (interface.yourTurn)
                    {
                        HStack
                        {
                            ForEach(((interface.table!).currentPlayer!).userOptions)
                            {
                                option in Button(option.name, action:
                                    {
                                        (interface.table!).userAction(option);
                                    }
                                );
                            }
                        }
                    }
                    else if (interface.roundEnd)
                    {
                        Button("Next Round", action: (interface.table!).roundComplete);
                    }
                }
            }
            .padding();
        }
    }
}
