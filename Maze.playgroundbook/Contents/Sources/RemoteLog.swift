//
//  RemoteLog.swift
//  Maze.playgroundbook
//
//  Created by Lukas Kollmer on 06/03/2017.
//  Copyright © 2017 Lukas Kollmer. All rights reserved.
//


// TODO remove all of this

import Foundation

let name = ProcessInfo.processInfo.processName
let pid = ProcessInfo.processInfo.processIdentifier
let threadId = pthread_mach_thread_np(pthread_self())

public func log(_ items: Any...) {
    return;

    do {
        let info: [String : Any] = [
            "name": name,
            "pid": pid,
            "threadid": threadId,
            "items": String(describing: items).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        ]

        let args: String = {
            var tmpString = ""
            for (key, value) in info {
                tmpString += "\(key)=\(value)&"
            }
            return tmpString
        }()

        let url = URL(string: "http://qyburn.local:3000/?\(args)")!

        _ = try Data(contentsOf: url)
    } catch {

    }
}