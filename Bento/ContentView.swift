import SwiftUI

extension EnvironmentValues {
    @Entry var direction: Axis = .vertical
}

struct SplitItem {
    var children: [SplitItem] = []
}

let sample = SplitItem(children: [
    .init(children: [
        .init(),
        .init(children: [
            .init(),
            .init(),
        ])
    ]),
    .init(),
    .init(children: [
        .init(),
        .init(),
    ]),
    .init(),
])

struct Bento: View {
    var split: SplitItem
    var axis: Axis = .vertical

    var body: some View {
        let layout = axis == .vertical ? AnyLayout(VStackLayout()) : .init(HStackLayout())
        layout {
            if split.children.count == 0 {
                Color.blue
            } else {
                ForEach(0..<split.children.count, id: \.self) { idx in
                    Bento(split: split.children[idx], axis: axis.other)
                }
            }
        }
    }
}

extension Axis {
    var other: Self {
        self == .horizontal ? .vertical : .horizontal
    }
}

struct Split<Content: View>: View {
    @Environment(\.direction) var axis
    @ViewBuilder var content: Content
    var body: some View {
        let layout = axis == .horizontal ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        layout {
            content
        }
        .environment(\.direction, axis.other)
    }
}

struct ContentView: View {
    var body: some View {
        Bento(split: sample)
    }
}

#Preview {
    ContentView()
}
