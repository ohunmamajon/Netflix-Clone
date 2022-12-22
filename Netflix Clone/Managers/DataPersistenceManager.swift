//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Okhunjon Mamajonov on 2022/12/23.
//

import Foundation
import UIKit
import CoreData
class DataPersistenceManager {
    enum  DatabaseError: Error {
        case  failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void){
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.original_name = model.original_name
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        do {
            try  context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
       
    }
    func fetchingTitlesFromDatabase(completion: @escaping(Result<[TitleItem], Error>)-> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<TitleItem>()
        request = TitleItem.fetchRequest()
        do{
          let titles =  try context.fetch(request)
            completion(.success(titles))
        }catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch{
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
