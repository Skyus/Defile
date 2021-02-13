import Foundation

/*
    Some Python/Node-inspired path functions.
*/

public enum Path {
    #if os(Windows)
    public static let separator: String = "\\"
    #else
    public static let separator: String = "/"
    #endif

    /*
        Aims to match shell dirname
    */
    public static func dirname(_ path: String) -> String {
        let p = UnsafeMutablePointer<Int8>(mutating: (path as NSString).utf8String)
        return String(cString: Foundation.dirname(p))
    }

    /*
        Aims to match shell basename
    */
    public static func basename(_ path: String, extension: String? = nil) -> String {
        let p = UnsafeMutablePointer<Int8>(mutating: (path as NSString).utf8String)
        let string: String = String(cString: Foundation.basename(p))

        
        if let ext = `extension` {
            let stringMinusExtension = String(string.prefix(string.count - ext.count))
            return stringMinusExtension.count == 0 ? string : stringMinusExtension
        }

        return string
    }

    /*
        Joins path components
    */
    public static func join(_ components: String...) -> String {
        var result = ""
        for (i, component) in components.filter({ $0 != "" }).enumerated() {
            result += component
            if !component.hasSuffix(separator) && i != (components.count - 1) {
                result += Path.separator
            }
        }
        return result
    }

    /*
        NSTempDir with suffix / removed
    */
    public static var tempdir: String {
        let tempdir: String = NSTemporaryDirectory()
        return Path.dirname(tempdir)
    }
}