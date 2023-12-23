import ArgumentParser
import SwishCore

@main
struct Swish: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        subcommands: [Run.self, Edit.self, Clean.self],
        defaultSubcommand: Run.self
    )
}

extension Swish {
    struct Options: ParsableArguments {
        @Option(name: .long)
        var libPath: Path = PathGenerator.defaultLibPath
        @Option(name: .long)
        var binPath = PathGenerator.defaultBinPath
        @Flag(name: .shortAndLong)
        var verbose: Bool = false
    }
}

extension Swish {
    static func commonAction(options: Options) {
        if options.verbose {
            Logger.level = .debug
        }
    }
}

func makeAbsolutePathIfNeeded(path: Path, relativeTo basePath: Path) -> Path {
    if path.isAbsolute {
        path
    } else {
        basePath.appending(path: path)
    }
}

extension Path: ExpressibleByArgument {
    public init(argument: String) {
        self.init(string: argument)
    }
}
