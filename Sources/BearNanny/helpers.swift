//
// Created by Hans Raaf on 25.08.17.
//

import Foundation


extension Substring {
    func trim() -> String {
        var cs = CharacterSet.whitespacesAndNewlines
        cs.insert(charactersIn: "\"'")
        return self.trimmingCharacters(in: cs)
    }
}

extension String {
    func stableHash() -> String {
        var result = UInt64(5381)
        let buf = [UInt8](self.utf8)
        for b in buf {
            result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
        }
        return String(result, radix: 36)
    }

    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var searchRange: Range<String.Index>?
        var count = 0
        while let foundRange = range(of: stringToFind, options: .diacriticInsensitive, range: searchRange) {
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
            count += 1
        }
        return count
    }
}

func chmod(_ path: String, _ perms: Int) throws {
    let fm = FileManager.default

    var attributes = [FileAttributeKey: Any]()
    attributes[.posixPermissions] = perms
    try fm.setAttributes(attributes, ofItemAtPath: path)
}

func fileModified(_ path: String) -> Date? {
    do {
        let attr = try FileManager.default.attributesOfItem(atPath: path)
        return attr[FileAttributeKey.modificationDate] as? Date
    } catch {
        return nil
    }
}
