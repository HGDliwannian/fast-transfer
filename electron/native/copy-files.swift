// AIGC START — 系统剪贴板写入/读取文件路径（访达可粘贴）
import Cocoa

let args = Array(CommandLine.arguments.dropFirst())

func readPathsFromPasteboard() -> [String] {
  let type = NSPasteboard.PasteboardType("NSFilenamesPboardType")
  guard let data = NSPasteboard.general.data(forType: type),
        let plist = try? PropertyListSerialization.propertyList(from: data, format: nil),
        let paths = plist as? [String] else {
    return []
  }
  return paths
}

if args.first == "--read-paths" {
  for p in readPathsFromPasteboard() {
    print(p)
  }
  exit(0)
}

guard !args.isEmpty else {
  fputs("usage: copy-files [--read-paths] <file>...\n", stderr)
  exit(2)
}

var paths: [String] = []
for p in args {
  let expanded = (p as NSString).expandingTildeInPath
  var isDir: ObjCBool = false
  guard FileManager.default.fileExists(atPath: expanded, isDirectory: &isDir), !isDir.boolValue else {
    fputs("missing file: \(p)\n", stderr)
    exit(3)
  }
  paths.append(expanded)
}

func xmlEscape(_ s: String) -> String {
  s
    .replacingOccurrences(of: "&", with: "&amp;")
    .replacingOccurrences(of: "<", with: "&lt;")
}

func buildFilenamesPlist(_ paths: [String]) -> String {
  let items = paths.map { "    <string>\(xmlEscape($0))</string>" }.joined(separator: "\n")
  return """
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <array>
  \(items)
  </array>
  </plist>
  """
}

let type = NSPasteboard.PasteboardType("NSFilenamesPboardType")
let data = buildFilenamesPlist(paths).data(using: .utf8)!
let pb = NSPasteboard.general
pb.clearContents()
pb.declareTypes([type], owner: nil)
guard pb.setData(data, forType: type) else {
  fputs("setData NSFilenamesPboardType failed\n", stderr)
  exit(1)
}
exit(0)
// AIGC END
