//
//  main.swift
//  update
//
//  Created by mikey on 14/07/2021.
//

import Foundation

print("[⚠️] Attempting to update stuff...")

let processingQueue = OperationQueue()
let brewArgs = ["update", "upgrade", "cleanup"]

runUpdate(commandPath: "/usr/local/bin/brew", args: brewArgs, emoji: "🍺")

processingQueue.waitUntilAllOperationsAreFinished()
