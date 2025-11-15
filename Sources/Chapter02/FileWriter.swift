import SystemPackage

public enum FileWriter {
    /// Writes data to a file at the specified path
    /// - Parameters:
    ///   - path: The file path to write to
    ///   - content: The string content to write
    /// - Throws: SystemCallError if file operations fail
    public static func writeToFile(path: FilePath, content: String) throws {
        // Create/open the file (equivalent to os.Create)
        let fd = try FileDescriptor.open(
            path,
            .writeOnly,
            options: [.create, .truncate],
            permissions: [.ownerReadWrite, .groupRead, .otherRead]
        )

        defer {
            try? fd.close()
        }

        // Write data to the file
        let data = Array(content.utf8)
        _ = try data.withUnsafeBytes { buffer in
            try fd.write(buffer)
        }
    }
}

@main
struct WriteToFile {
    static func main() {
        do {
            try FileWriter.writeToFile(
                path: FilePath("test.txt"),
                content: "os.File example\n"
            )
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
