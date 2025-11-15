@testable import Chapter02
import Foundation
import SystemPackage
import Testing

@Suite("FileWriter Tests")
struct FileWriterTests {
    @Test("Creates file with correct content")
    func createsFileWithCorrectContent() throws {
        // Given
        let testFilePath = FilePath("/tmp/test_\(UUID().uuidString).txt")
        defer { try? FileManager.default.removeItem(atPath: testFilePath.string) }
        let expectedContent = "Hello, swift-system!\n"

        // When
        try FileWriter.writeToFile(path: testFilePath, content: expectedContent)

        // Then
        let actualContent = try String(contentsOfFile: testFilePath.string, encoding: .utf8)
        #expect(actualContent == expectedContent)
    }

    @Test("Truncates existing file")
    func truncatesExistingFile() throws {
        // Given
        let testFilePath = FilePath("/tmp/test_\(UUID().uuidString).txt")
        defer { try? FileManager.default.removeItem(atPath: testFilePath.string) }
        let initialContent = "This is some initial content that should be overwritten\n"
        let newContent = "New content\n"

        // When
        try FileWriter.writeToFile(path: testFilePath, content: initialContent)
        try FileWriter.writeToFile(path: testFilePath, content: newContent)

        // Then
        let actualContent = try String(contentsOfFile: testFilePath.string, encoding: .utf8)
        #expect(actualContent == newContent)
        #expect(actualContent != initialContent)
    }

    @Test("Handles empty string")
    func handlesEmptyString() throws {
        // Given
        let testFilePath = FilePath("/tmp/test_\(UUID().uuidString).txt")
        defer { try? FileManager.default.removeItem(atPath: testFilePath.string) }
        let emptyContent = ""

        // When
        try FileWriter.writeToFile(path: testFilePath, content: emptyContent)

        // Then
        let actualContent = try String(contentsOfFile: testFilePath.string, encoding: .utf8)
        #expect(actualContent == emptyContent)
    }

    @Test("Handles multiline content")
    func handlesMultilineContent() throws {
        // Given
        let testFilePath = FilePath("/tmp/test_\(UUID().uuidString).txt")
        defer { try? FileManager.default.removeItem(atPath: testFilePath.string) }
        let multilineContent = """
        Line 1
        Line 2
        Line 3

        """

        // When
        try FileWriter.writeToFile(path: testFilePath, content: multilineContent)

        // Then
        let actualContent = try String(contentsOfFile: testFilePath.string, encoding: .utf8)
        #expect(actualContent == multilineContent)
    }

    @Test("Handles unicode content")
    func handlesUnicodeContent() throws {
        // Given
        let testFilePath = FilePath("/tmp/test_\(UUID().uuidString).txt")
        defer { try? FileManager.default.removeItem(atPath: testFilePath.string) }
        let unicodeContent = "Hello 世界 🌍!\n"

        // When
        try FileWriter.writeToFile(path: testFilePath, content: unicodeContent)

        // Then
        let actualContent = try String(contentsOfFile: testFilePath.string, encoding: .utf8)
        #expect(actualContent == unicodeContent)
    }

    @Test("File has correct permissions")
    func fileHasCorrectPermissions() throws {
        // Given
        let testFilePath = FilePath("/tmp/test_\(UUID().uuidString).txt")
        defer { try? FileManager.default.removeItem(atPath: testFilePath.string) }
        let content = "Permission test\n"

        // When
        try FileWriter.writeToFile(path: testFilePath, content: content)

        // Then
        let attributes = try FileManager.default.attributesOfItem(atPath: testFilePath.string)
        let permissions = attributes[.posixPermissions] as? NSNumber

        // Expected: owner read/write (0o600) + group read (0o040) + other read (0o004) = 0o644
        #expect(permissions?.uint16Value == 0o644)
    }
}
