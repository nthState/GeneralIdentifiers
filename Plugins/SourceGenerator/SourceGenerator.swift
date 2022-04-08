import PackagePlugin
import Foundation

/**
 https://github.com/apple/swift-evolution/blob/main/proposals/0303-swiftpm-extensible-build-tools.md
 */
@main
struct SourceGenerator: BuildToolPlugin {

  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {

    // Load the configuration file
    let configurationPath = context.package.directory.appending("SourceGeneratorConfiguration.json")
    guard let configurationData = try? Data(contentsOf: configurationPath.url) else {
      fatalError("Configuration file not found")
    }

    // Decode configuration
    let configuration: SourceGeneratorConfiguration
    do {
      configuration = try JSONDecoder().decode(SourceGeneratorConfiguration.self, from: configurationData)
    } catch let error {
      print(error)
      fatalError(error.localizedDescription)
    }

    Diagnostics.remark("configuration: \(configuration)")

    // What data file are we going to use?
    let input = context.package.directory.appending(configuration.sourceName)

    // Pick a decoder
    let parser: Parseable
    switch configuration.sourceName {
    case _ where configuration.sourceName.hasSuffix(".csv"):
      parser = CSVParser(source: input, configuration: configuration)
      Diagnostics.remark("CSV Type")
    case _ where configuration.sourceName.hasSuffix(".json"):
      parser = JSONParser(source: input, configuration: configuration)
      Diagnostics.remark("JSON Type")
    default:
      fatalError("Unable to recognise source type")
    }

    // Generate output
    let outputData = parser.generate()
    Diagnostics.remark("Output generated, \(String(describing: outputData?.count)) bytes")

    // Create output file
    let outputFolder = context.pluginWorkDirectory.appending("GeneratedSources")

    // Ensure output folder available
    do {
      try FileManager.default.createDirectory(at: URL(fileURLWithPath: outputFolder.string), withIntermediateDirectories: true, attributes: nil)
    } catch let error {
      Diagnostics.error(error.localizedDescription)
    }

    let outputFile = outputFolder.appending("GeneralIdentifiers+.swift")

    // Write output to disk
    let written = FileManager.default.createFile(atPath: outputFile.string, contents: outputData)
    if !written {
      Diagnostics.error("Failed to write: \(outputFile)")
    } else {
      Diagnostics.remark("Output file written: \(outputFile)")
    }


    // Passes the outputFilesDirectory to the next build stage
    return [.prebuildCommand(displayName: "Test",
                             executable: .init("/bin/cp"),
                             arguments: [
                              //                                                            src.string,
                              //                                                            outputPath.string
                             ],
                             outputFilesDirectory: outputFolder)]
  }

}

