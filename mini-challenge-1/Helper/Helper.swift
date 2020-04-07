//
//  Helper.swift
//  mini-challenge-1
//
//  Created by Dicky Geraldi on 05/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Helper {
    
    // function for delete rows in core data by id
    func deleteData(entity: String, uniqueId: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueId)
        
        do{
            let dataToDelete = try managedContext.fetch(fetchRequest)[0] as! NSManagedObject
            managedContext.delete(dataToDelete)
            
            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
    
    // function for update rows in core data by id
    func updateDate(entity: String, uniqueId: String, newData: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueId)
        
        do{
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            
            if entity == "Goal" {
                dataToUpdate.setValue(newData, forKey: "goalName")
            } else if entity == "Task" {
                dataToUpdate.setValue(newData, forKey: "taskName")
            }
            
            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
    
    // function for store data by entity and Data
    func storeData(entity: String, dataGoals: Goals, dataTask: Tasks) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext

        let dataOfEntity = NSEntityDescription.entity(forEntityName: entity, in: context)!

        let listOfEntity = NSManagedObject(entity: dataOfEntity, insertInto: context)

        if entity == "Goal" {
            
            listOfEntity.setValue(dataGoals.id, forKey: "id")
            listOfEntity.setValue(dataGoals.goalName, forKey: "goalName")
            listOfEntity.setValue(dataGoals.date, forKey: "date")
            listOfEntity.setValue(dataGoals.status, forKey: "status")
            
        } else if entity == "Task" {
            
            listOfEntity.setValue(dataTask.id, forKey: "id")
            listOfEntity.setValue(dataTask.goalId, forKey: "goalId")
            listOfEntity.setValue(dataTask.taskName, forKey: "taskName")
            listOfEntity.setValue(dataTask.start, forKey: "start")
            listOfEntity.setValue(dataTask.duration, forKey: "duration")
            listOfEntity.setValue(dataTask.distraction, forKey: "distraction")
            listOfEntity.setValue(dataTask.status, forKey: "status")
        
        }

        do {
            
           try context.save()
           print("Success save data")
        
        } catch let error as NSError {
           
            print("Gagal save context \(error), \(error.userInfo)")
        
        }
    }
    
    // Function for checking all data on core Data
    func retrieveData(entity: String, conditional: String) -> ([Goals], [Tasks], ReportData) {
        
        var tempGoals: [Goals] = []
        var tempTask: [Tasks] = []
        var countingDistraction: Int = 0
        var countingGoalsDone: Int = 0
        var countintTasksDone: Int = 0
        var countingProductiveDuration: Int = 0
        var reportData: ReportData = ReportData.init(totalGoalsCompleted: countingGoalsDone, totalTaskCompleted: countintTasksDone, productivetime: countingProductiveDuration, totalTimeDistraction: countingDistraction)
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return (tempGoals, tempTask, reportData) }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            
            let result = try context.fetch(fetch)
            
            if entity == "Goal" {
                    
                for data in result as! [NSManagedObject] {
                    
                    if data.value(forKey: "status") as! Bool == true {
                        countingGoalsDone += 1
                    }
                    
                    tempGoals.append(Goals(date: data.value(forKey: "date") as! String, goalName: data.value(forKey: "goalName") as! String, id: data.value(forKey: "id") as! String, status: data.value(forKey: "status") as! Bool))
                }

            } else if entity == "Task" {
                
                for data in result as! [NSManagedObject] {
                    
                    if data.value(forKey: "status") as! Bool == true {
                        countintTasksDone += 1
                        countingProductiveDuration += data.value(forKey: "duration") as! Int
                        countingDistraction += data.value(forKey: "distraction") as! Int
                    }
                    
                    if data.value(forKey: "goalId") as! String == conditional {
                        
                        tempTask.append(Tasks(distraction: data.value(forKey: "distraction") as! Int, duration: data.value(forKey: "duration") as! Int, goalId: data.value(forKey: "goalId") as! String, id: data.value(forKey: "id") as! String, start: data.value(forKey: "start") as! String, status: data.value(forKey: "status") as! Bool, taskName: data.value(forKey: "taskName") as! String))
                        
                    }
                    
                }
                
            }
            
        } catch {
            print("Failed")
        }
        
        reportData.productiveTime = countingProductiveDuration
        reportData.totalGoalsCompleted = countingGoalsDone
        reportData.totalTaskCompleted = countintTasksDone
        reportData.totalTimeDistraction = countingDistraction
        
        return (tempGoals, tempTask, reportData)
    }
}