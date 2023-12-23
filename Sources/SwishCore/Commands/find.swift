//
//  find.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/15.
//

import Foundation

public struct FileSearchSequence: Sequence {
    let path: Path
    let depth: Int?

    public struct Iterator: IteratorProtocol {
        private let path: Path
        private let depth: Int?
        var enumerator: FileManager.DirectoryEnumerator?

        init(path: Path, depth: Int?) {
            self.path = path
            self.depth = depth
            enumerator = FileManager.default.enumerator(atPath: path.string)
        }

        public mutating func next() -> Path? {
            guard let enumerator else {
                return nil
            }

            guard 
                let file = enumerator.nextObject() as? String,
                let attribute = enumerator.fileAttributes?[.type] as? String
            else {
                return nil
            }

            if attribute == FileAttributeType.typeDirectory.rawValue,
               let depth,
               enumerator.level >= depth {
                enumerator.skipDescendants()
            }

            return path + file
        }
    }

    public func makeIterator() -> Iterator {
        Iterator(path: path, depth: depth)
    }
}

public func find(at path: Path, depth: Int? = nil) -> FileSearchSequence {
    FileSearchSequence(path: path, depth: depth)
}

public func find(atPath path: String, depth: Int? = nil) -> FileSearchSequence {
    FileSearchSequence(path: Path(string: path), depth: depth)
}
