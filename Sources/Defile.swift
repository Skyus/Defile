/*
    Defile.swift
    A C-file wrapper for Swift because Foundation's API proved too difficult for me to use.
*/
import Foundation

public enum DefileModes
{
    case read
    case write
    case append
}

public enum DefileError: Error
{
    case modeMismatch
    case writeFailure
    case noFileOpen
    case null
}

extension String
{
    public func replacing(_ extensions: [String], with replacement: String) -> String
    {
        var components = self.components(separatedBy: ".")
        let last = components.count - 1
        if extensions.contains(components[last])
        {
            components.remove(at: last)
        }
        components.append(replacement)
        return components.joined(separator: ".")
    }
}

public class Defile
{
    private var file: UnsafeMutablePointer<FILE>
    private var mode: DefileModes
    private var storage: [UInt8]
    private var cOpen: Bool

    /*
     Initializes file.
     
     path: The give path (or filename) to open the file in.
     
     mode: .read, .write or .append.
        *.read opens file for reading. If the file does not exist, the initializer fails.
        *.write opens file for writing. If the file does not exist, it will be created.
        *.append opens the file for appending more information to the end of the file. If the file does not exist, it will be created.
     
    */
    public init?(_ path: String, mode: DefileModes = .read)
    {
        var modeStr: String
        
        switch(mode)
        {
            case .read:
                modeStr = "r"
            case .write:
                modeStr = "w"
            case .append:
                modeStr = "a"
        }
        
        guard let file = fopen(path, modeStr)
        else
        {
            return nil
        }

        self.file = file        
        self.mode = mode
        self.storage = []            

        cOpen = true;

        if (mode == .read)
        {
            var character = fgetc(file)
            
            while character != EOF
            {
                storage.append(UInt8(character))
                character = fgetc(file)
            }

            fclose(file)
            cOpen = false;
        }
    }

    public func close()
    {
        if cOpen
        {
            fclose(file)
            cOpen = false
        }
    }

    deinit
    {
        close()
    }
    
    /*
        Returns entire file as a UTF-8-based string.

        Fails if mode is not 'read' or if the file is not valid UTF-8.
    */
    public var string: String?
    {
        if mode != .read
        {
            return nil
        }

        guard let convertible = String(data: Data(storage), encoding: .utf8)
        else
        {
            return nil
        }

        return convertible
    }

    /*
        Returns files as lines. Pretty popular for text processing.

        Fails for the same reasons property "string" would fail.
    */

    public var lines: [String]?
    {
        if mode != .read
        {
            return nil
        }

        guard let result = self.string?.components(separatedBy: "\n")
        else
        {
            return nil
        }

        return result
    }

    /*
        Returns UTF-8 array of the file.
    */
    public var bytes: [UInt8]?
    {
        if mode != .read
        {
            return nil
        }

        return storage        
    }

    /*
        Writes binary data to file.

        Fails on mode mismatch or if the file is already closed.
    */
    public func write(bytes: [UInt8]) throws
    {
        if mode == .read
        {
            throw DefileError.modeMismatch
        }

        if !cOpen
        {
            throw DefileError.noFileOpen
        }

        for byte in bytes
        {
            if (fputc(Int32(byte), file) == EOF)
            {
                throw DefileError.writeFailure
            }
        }
    }

    /*
        Writes string to file.

        Fails for the same reasons as bytes, which it uses.
    */
    public func write(string: String) throws
    {
        do
        {
            try self.write(bytes: [UInt8](Array(string.utf8)))
        }
        catch
        {
            throw error
        }      
    }

    /*
        Writes string to file, adding newline.

        Fails for the same reasons as write, which it uses.
    */
    public func puts(string: String) throws
    {
        do
        {
            try self.write(string: string + "\n")
        }
        catch
        {
            throw error
        }
    }
}