#!/usr/bin/env swift -enable-bare-slash-regex

import Foundation

extension String {
  func deletingSuffix(_ suffix: String) -> String {
    guard hasSuffix(suffix) else { return self }
    return String(dropLast(suffix.count))
  }
}

func shorten(_ version: Substring) -> String {
  (version.count >= 5 ? String(version).deletingSuffix(".0") : String(version))
    .replacingOccurrences(of: ".0RC", with: "RC")
}

let pages = (try! FileManager.default.contentsOfDirectory(atPath: "html"))
  .filter { $0.hasSuffix(".html") }
  .filter { $0.hasPrefix("ST_") || $0.hasPrefix("RT_") }
  .map { $0.replacingOccurrences(of: ".html", with: "") }

for page in pages {
  //print(page)

  let path = "./html/" + page + ".html"
  var string = try! String(contentsOfFile: path)

  let regex = /<p>Availability: (?:PostGIS )?(?<version>\d+\.\d+(?:\.\d+)?(?:RC\d+)?)(?:\s+-\s+|,\s+|\s+)?(?<extra>[^<]+)?<\/p>/
  guard let match = try! regex.firstMatch(in: string) else { continue }
  var badges = #"<span class="badge platform">PostGIS "# + shorten(match.version) + #"+</span>"#
  print((shorten(match.version), match.extra))

  let regex2 = /requires -? ?(?<lib>[^&]+) (?:&gt;= )?(?<version>\d+\.\d+(?:\.\d+)?(?:RC\d+)?)\+?\.?\s*/
  if let extra = match.extra, let match = try! regex2.ignoresCase().firstMatch(in: extra) {
    print((match.lib, shorten(match.version)))
    badges += #"<span class="badge platform">"# + match.lib + " " + shorten(match.version) + #"+</span>"#
  }

//  string = string.replacingOccurrences(
//    of: #"</div><div class="refsynopsisdiv">"#,
//    with: #"</div>"# + badges + #"<div class="refsynopsisdiv">"#
//  )
//  try! string.write(toFile: path, atomically: true, encoding: .utf8)
}
