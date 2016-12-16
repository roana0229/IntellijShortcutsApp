//
//  LocalVariableCommand.swift
//  Palette
//
//  Created by 堤下薫 on 2016/12/14.
//  Copyright © 2016年 roana0229. All rights reserved.
//

import Cocoa
import Foundation
import XcodeKit

class LocalVariableCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "IntellijShortcuts-Local-Variable", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }

        // ファイルの行全体を取得
        let lines = invocation.buffer.lines
        // 選択している行を取得
        if var line = lines[selection.start.line] as? String {
            // 行頭のスペースを変数へ格納
            var space = ""
            while line.characters.first == " " {
                line = String(line.characters.dropFirst())
                space += " "
            }

            if line.hasPrefix("var ") {
                // var だったら let に切り替え
                let code = line.replacingOccurrences(of: "var", with: "let")
                lines.replaceObject(at: selection.start.line, with: "\(space)\(code)")
            } else if line.hasPrefix("let ") {
                // let だったら var に切り替え
                let code = line.replacingOccurrences(of: "let", with: "var")
                lines.replaceObject(at: selection.start.line, with: "\(space)\(code)")
            } else {
                // var <##> = value のフォーマットを挿入する
                let code = "var <##> = \(line)"
                lines.replaceObject(at: selection.start.line, with: "\(space)\(code)")
            }
        }

        completionHandler(nil)
    }

}
