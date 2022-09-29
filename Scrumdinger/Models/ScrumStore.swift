//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Sai Lakshmi on 6/9/22.
//

import Foundation
import SwiftUI

//class to serve as the data model for your app.
///ObservableObject is a class-constrained protocol for connecting external model data to SwiftUI views.
class ScrumStore: ObservableObject {
    ///An ObservableObject includes an objectWillChange publisher that emits when one of its @Published properties is about to change.
    ///Any view observing an instance of ScrumStore will render again when the scrums value changes.
    @Published var scrums: [DailyScrum] = []
    
    ///Scrumdinger will load and save scrums to a file in the user’s Documents folder. You’ll add a function that makes accessing that file more convenient.
    private static func fileURL() throws -> URL {
        ///You use the shared instance of the FileManager class to get the location of the Documents directory for the current user.
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("scrums.data")
    }
    
    
    static func load() async throws -> [DailyScrum] {
        ///Calling withCheckedThrowingContinuation suspends the load function, then passes a continuation into a closure that you provide. A continuation is a value that represents the code after an awaited function.
        try await withCheckedThrowingContinuation { continuation in ///In the closure, call the legacy load function with a completion handler.
            load { result in                        ///Recall that the completion handler receives a Result<[DailyScrum], Error> enumeration.
                switch result {
                    ///Upon failure, send the error to the continuation closure. The system throws an error when the async task resumes.
                case .failure(let error):
                    continuation.resume(throwing: error)
                    ///Upon success, send the scrums to the continuation closure. The array of scrums becomes the result of the withCheckedThrowingContinuation call when the async task resumes.
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        }
    }
    
    
    
    ///Result is a single type that represents the outcome of an operation, whether it’s a success or failure.
    ///The load function accepts a completion closure that it calls asynchronously with either an array of scrums or an error.
    static func load(completion: @escaping (Result<[DailyScrum], Error>)->Void) {
        ///Create an asynchronous block on a background queue.
        ///Dispatch queues are first in, first out (FIFO) queues to which your application can submit tasks. Background tasks have the lowest priority of all tasks.
        DispatchQueue.global(qos: .background).async {
            ///Add a do-catch statement to handle any errors with loading data.
            do {
                ///create a local constant for the file URL.
                let fileURL = try fileURL()
                ///Create a file handle for reading scrums.data.
                ///Because scrums.data doesn’t exist when a user launches the app for the first time, you call the completion handler with an empty array if there’s an error opening the file handle.
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                ///Decode the file’s available data into a local constant named dailyScrums.
                let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                ///On the main queue, pass the decoded scrums to the completion handler.
                ///You perform the longer-running tasks of opening the file and decoding its contents on a background queue. When those tasks complete, you switch back to the main queue.
                DispatchQueue.main.async {
                    completion(.success(dailyScrums))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: scrums) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    ///This method accepts a completion handler that accepts either the number of saved scrums or an error.
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>)->Void) {
        
    }
}
