# Defile
A C-File wrapper for Swift, with syntax and semantics inspired by scripting languages.

(An older version can be found in the source files for [Oak](https://github.com/Skyus/Oak)).

# Dependencies
Swift 3.0+ on either macOS or Linux.

# Usage
To use this in your app, either copy the single source file to your app's directory, drag the Xcode project to your Xcode sidebar or add the following to your Package.swift file:

```swift
    .Package(url: "https://github.com/Skyus/Defile.git", majorVersion: 2, minor: 0)
```

If you want to use it in a single source file, you may want to look into [quips](https://github.com/skyus/quips), where you can import Defile like this:

```swift
    @quip Defile:"https://github.com/Skyus/Defile.git":2:0
```

# License
The Unlicense public domain dedication. Check 'UNLICENSE'.