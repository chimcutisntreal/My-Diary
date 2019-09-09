
import UIKit

extension ListAudioTableViewController: FileManagerDelegate {
    
    func fileManager(_ fileManager: FileManager, shouldMoveItemAt srcURL: URL, to dstURL: URL) -> Bool {
        return true
    }
}
