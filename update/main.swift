//
//  main.swift
//  update
//
//  Created by mikey on 14/07/2021.
//

import Foundation
import os

print("Hello, World!")

let logger = Logger(subsystem: "com.0xmachos.update", category: "command execution")

func runCommand(command: String, args: [String]) -> Void {
    
    processingQueue.addOperation {
        let pipe = Pipe()
        let process = Process()
        process.executableURL = URL(fileURLWithPath:"\(command)")
        process.arguments = args
        process.terminationHandler = { (process) in
        
            print("Finished \(!process.isRunning)")
        }
        process.standardOutput = pipe
        process.waitUntilExit()
        do{
          try process.run()
          let data = pipe.fileHandleForReading.readDataToEndOfFile()
          if let output = String(data: data, encoding: String.Encoding.utf8) {
            print(output)
          }
        } catch {
            print(error)
            logger.error("\(error.localizedDescription)")
            exit(1)
        }
    }
}

let processingQueue = OperationQueue()

runCommand(command: "/usr/local/bin/brew", args: ["update"])

processingQueue.waitUntilAllOperationsAreFinished()

