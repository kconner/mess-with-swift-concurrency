import Foundation

@available(macOS 9999, *)
actor Client {

    func done(name: String, description: String) {
        print("Client.done", name, description)
    }

}
