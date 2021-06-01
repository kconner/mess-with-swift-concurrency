import Foundation

@available(macOS 9999, *)
actor EventServer {

    private var events: [String : Event] = [:]
    private var clients: [Client] = []

    func subscribe(client: Client) {
        print("EventServer.subscribe")
        clients.append(client)
    }

    func add(name: String, description: String, duration: TimeInterval) throws {
        print("EventServer.add")
        events[name] = Event(
            server: self,
            name: name,
            description: description,
            duration: duration
        )
    }

    func cancel(name: String) async {
        print("EventServer.cancel")
        guard let event = events[name] else { return }

        await event.cancel()
        events[name] = nil
    }

    func done(name: String, description: String) async {
        print("EventServer.done")
        events[name] = nil

        await withTaskGroup(of: Void.self) { group in
            for client in clients {
                group.async {
                    await client.done(name: name, description: description)
                }
            }
        }
    }

}

