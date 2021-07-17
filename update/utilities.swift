//
//  utilities.swift
//  update
//
//  Created by mikey on 16/07/2021.
//

import Foundation
import os

func runCommand(command: String, args: [String]) -> Bool {
    let logger = Logger(subsystem: "com.0xmachos.update", category: "command execution")
    var ranSuccessfully: Bool = false
    let outPipe = Pipe()
    let errPipe = Pipe()
    let process = Process()
    var output: String = ""
    var error: String = ""
    process.executableURL = URL(fileURLWithPath: "\(command)")
    process.arguments = args
    process.standardOutput = outPipe
    process.standardError = errPipe
    process.waitUntilExit()
    processingQueue.addOperation {

        do {
            try process.run()
            logger.info("Executed \(command) \(args.joined(separator: ""))")

            let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
            let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
            output = String(data: outData, encoding: String.Encoding.utf8)!
            error = String(data: errData, encoding: String.Encoding.utf8)!

        } catch {
            print(error.localizedDescription)
            logger.error("\(error.localizedDescription)")
            ranSuccessfully = false
        }

        process.waitUntilExit()
        let exitStatus = process.terminationStatus
        if exitStatus == 0 {
            print(output)
            logger.info("\(command) \(args.joined(separator: "")) ran successfully")
            ranSuccessfully = true
        } else {
            print(error)
            logger.error("\(error)")
            ranSuccessfully = false
        }
    }
    return ranSuccessfully
}


func checkFileExistsAndExecutable(path: String) -> Bool {
    let logger = Logger(subsystem: "com.0xmachos.update", category: "Executable Check")
    let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            if fileManager.isExecutableFile(atPath: path) {
                logger.info("\(path) exists and is executable")
                return true
            } else {
                print(("\(path) exists but is not executable"))
                logger.error("\(path) exists but is not executable")
                return false
            }
        } else {
            print("\(path) exists but is not executable")
            logger.error("\(path) does not exist")
            return false
        }
}

func runUpdate(commandPath: String,  args: [String], emoji: String){
    
    let commandName = (commandPath as NSString).lastPathComponent
    
    if checkFileExistsAndExecutable(path: commandPath){
        print("[\(emoji)] Updating \(commandName)...")
    } else {
        return
    }
    
    for arg in args {
        if !runCommand(command: commandPath, args: [arg]){
            return
        }
    }
}


