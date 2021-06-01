import Foundation

@main
@available(macOS 9999, *)
struct Main {
    static func main() async throws {
        let server = EventServer()

        await server.subscribe(client: Client())

        try await server.add(name: "ev", description: "desc", duration: 5.0)

        await sleep(for: 1)
        await server.cancel(name: "ev")

        try await server.add(name: "ev", description: "desc", duration: 2.0)
        await server.subscribe(client: Client())

        await sleep(for: 5)
    }
}

@available(macOS 9999, *)
func sleep(for duration: TimeInterval) async {
    await Task.sleep(UInt64(duration * 1_000_000_000))
}
