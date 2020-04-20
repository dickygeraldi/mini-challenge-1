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
    func updateDate(entity: String, uniqueId: String, taskName: String, duration: Int, start: String) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueId)
        
        do{
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
        
            dataToUpdate.setValue(taskName, forKey: "taskName")
            dataToUpdate.setValue(duration, forKey: "duration")
            dataToUpdate.setValue(start, forKey: "start")
            
            try managedContext.save()
        }catch let err{
            print(err)
        }
        
        return "00"
    }
    
    // function for store data by entity and Data
    func storeData(entity: String, dataGoals: Goals? = nil,  dataTask: Tasks?) -> String {
        
        var message: String = ""
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }

        let context = appDelegate.persistentContainer.viewContext

        let dataOfEntity = NSEntityDescription.entity(forEntityName: entity, in: context)!

        let listOfEntity = NSManagedObject(entity: dataOfEntity, insertInto: context)

        if entity == "Goal" {
            
            listOfEntity.setValue(dataGoals?.id, forKey: "id")
            listOfEntity.setValue(dataGoals?.goalName, forKey: "goalName")
            listOfEntity.setValue(dataGoals?.date, forKey: "date")
            listOfEntity.setValue(dataGoals?.status, forKey: "status")
            
        } else if entity == "Task" {
            
            listOfEntity.setValue(dataTask?.id, forKey: "id")
            listOfEntity.setValue(dataTask?.goalId, forKey: "goalId")
            listOfEntity.setValue(dataTask?.taskName, forKey: "taskName")
            listOfEntity.setValue(dataTask?.start, forKey: "start")
            listOfEntity.setValue(dataTask?.duration, forKey: "duration")
            listOfEntity.setValue(dataTask?.distraction, forKey: "distraction")
            listOfEntity.setValue(dataTask?.status, forKey: "status")
        
        }

        do {
            
           try context.save()
            message = "00"
        } catch let error as NSError {
           
            print("Gagal save context \(error), \(error.userInfo)")
            message = "01"
        }
        
        return message
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
        let sort = NSSortDescriptor(key: "start", ascending: false)
        fetch.sortDescriptors = [sort]
        
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

                    print("Dicky Tracking: \(data.value(forKey: "distraction") as! Int)")
//                    if data.value(forKey: "goalId") as! String == conditional {
                    
                    tempTask.append(Tasks(distraction: data.value(forKey: "distraction") as! Int, duration: data.value(forKey: "duration") as! Int, goalId: data.value(forKey: "goalId") as! String, id: data.value(forKey: "id") as! String, start: data.value(forKey: "start") as! String, status: data.value(forKey: "status") as! Bool, taskName: data.value(forKey: "taskName") as! String))
                    
//                    }
                    
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
    
    // Function for checking all data on core Data
    func retrieveDataBygoals(entity: String) -> ([String: [Tasks]]) {
        
        var taskPerGoals = [String: [Tasks]]()
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return (taskPerGoals) }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let sort = NSSortDescriptor(key: "start", ascending: false)
        fetch.sortDescriptors = [sort]
        
        do {
            
            let result = try context.fetch(fetch)
            var tasks: [Tasks]
            
            for data in result as! [NSManagedObject] {
                
                if taskPerGoals[data.value(forKey: "goalId") as! String] != nil {
                    
                    tasks = taskPerGoals[data.value(forKey: "goalId") as! String]!
                    tasks.append(Tasks(distraction: data.value(forKey: "distraction") as! Int, duration: data.value(forKey: "duration") as! Int, goalId: data.value(forKey: "goalId") as! String, id: data.value(forKey: "id") as! String, start: data.value(forKey: "start") as! String, status: data.value(forKey: "status") as! Bool, taskName: data.value(forKey: "taskName") as! String))
                    
                } else {
                    
                    tasks = [Tasks(distraction: data.value(forKey: "distraction") as! Int, duration: data.value(forKey: "duration") as! Int, goalId: data.value(forKey: "goalId") as! String, id: data.value(forKey: "id") as! String, start: data.value(forKey: "start") as! String, status: data.value(forKey: "status") as! Bool, taskName: data.value(forKey: "taskName") as! String)]
                    
                }
                                
                taskPerGoals.updateValue(tasks, forKey: data.value(forKey: "goalId") as! String)
                
            }
            
        } catch {
            print("Failed")
        }
        
        return (taskPerGoals)
    }
    
    // Function for checking all data on core Data
    func countingTaskData(entity: String, conditional: String) -> Int {
        
        var counting: Int = 0
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return counting }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let sort = NSSortDescriptor(key: "start", ascending: false)
        fetch.sortDescriptors = [sort]
        
        do {
            let result = try context.fetch(fetch)
            
            for _ in result as! [NSManagedObject] {
                counting += 1
            }
    
        } catch {
            print("Failed")
        }
        
        return counting
    }
    
    func finishTask(data task: Tasks) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id = %@", task.id)
        
        do{
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            	
            dataToUpdate.setValue(task.distraction, forKey: "distraction")
            dataToUpdate.setValue(task.status, forKey: "status")
            
            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
}

extension UITextField {
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))

        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setupTextField() {
        self.layer.borderColor = #colorLiteral(red: 0.6571614146, green: 0.6571771502, blue: 0.6571686864, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
    }
}

extension UIButton {
    func roundCorners(){
        let radius = self.frame.size.width / 2
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
