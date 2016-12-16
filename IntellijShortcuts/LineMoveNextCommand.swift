//
//  LineMoveNextCommand.swift
//  Palette
//
//  Created by 堤下薫 on 2016/12/14.
//  Copyright © 2016年 roana0229. All rights reserved.
//

import Cocoa
import Foundation
import XcodeKit

class LineMoveNextCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "IntellijShortcuts-Line-Move-Next", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }
        
        // ファイルの行全体を取得
        let lines = invocation.buffer.lines
        // 選択している次の行を取得
        if let nextLine = lines[selection.start.line+1] as? String {
            // 次の行を削除し、選択している行へ挿入することで下にずらす
            lines.removeObject(at: selection.start.line+1)
            lines.insert(nextLine, at: selection.start.line)
        }
        
        completionHandler(nil)
    }
    
}
