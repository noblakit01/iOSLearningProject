import Foundation

public func exampleOf(description: String, @noescape action: Void -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}
