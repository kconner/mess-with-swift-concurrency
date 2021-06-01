import Foundation

@available(macOS 9999, *)
actor Event {

    private weak var server: EventServer?

    private let name: String
    private let description: String

    private var timer: Task<Void, Error>?

    init(server: EventServer, name: String, description: String, duration: TimeInterval) {
        self.server = server
        self.name = name
        self.description = description

        timer = Task {
            [weak self] in
            await sleep(for: duration)
            try Task.checkCancellation()
            await self?.notify()
        }
    }

    deinit {
        print("Event.deinit")
    }

    private func notify() async {
        print("Event.notify")
        await server?.done(name: name, description: description)
    }

    func cancel() {
        print("Event.cancel")
        self.timer?.cancel()
        self.timer = nil
    }

}
