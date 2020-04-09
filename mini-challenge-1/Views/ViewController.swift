//
//  ViewController.swift
//  mini-challenge-1
//
//  Created by Dicky Geraldi on 03/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit
import CoreData

protocol goalsData{
    func storeDataToGoal(entity: String, name: String, status: BooleanLiteralType)
    func reloadCollection()
}
class ViewController: UIViewController, goalsData {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addTaskPerGoals: UIButton!
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dateFormat1: DateFormatter = DateFormatter ()
    var dateString : String = ""
    var dateString2 : String = "" //untuk format date yang beda di halaman Report
    let dateFormat2: DateFormatter = DateFormatter ()
    
    var goalIdArray : [String] = []
    
    var taskPerGoals = [String: [Tasks]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        to delete goal data
//        deleteGoalData(entity: "Goal", uniqueId: "0")
//        deleteGoalData(entity: "Goal", uniqueId: "1")
//        deleteGoalData(entity: "Goal", uniqueId: "2")
        
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        
        self.navigationController?.isNavigationBarHidden = true //untuk hilangin navigation bar
        showDate()//untuk set dateLabel jadi tanggal hari ini
        
        //updateDateData(entity: "Goal", uniqueId: "1", newDate: "09/04/20")
       // updateDateData(entity: "Goal", uniqueId: "2", newDate: "09/04/20")
        
        /*data dummy
         //storeDataToGoal(entity: "Goal", id: "1", name: "Mini challenge 1", date: dateString, status: false)
       // storeDataToGoal(entity: "Goal", id: "2", name: "Mini challenge 2", date: dateString, status: true)
         storeDataToGoal(entity: "Goal", id: "3", name: "Mini challenge 3", date: dateString, status: false)
        
        //storeDataToTask(entity: "Task", id: "1", goalId: "1", taskName: "Wireframe", start: "13:00", duration: 60, distraction: 8, status: true)
       //storeDataToTask(entity: "Task", id: "2", goalId: "1", taskName: "Mockup", start: "14:00", duration: 60, distraction: 2, status: false)
       //storeDataToTask(entity: "Task", id: "3", goalId: "1", taskName: "Prototype", start: "15:00", duration: 120, distraction: 1, status: true)
       //storeDataToTask(entity: "Task", id: "4", goalId: "2", taskName: "Develop", start: "17:00", duration: 40, distraction: 3, status: true)
       
        storeDataToTask(entity: "Task", id: "5", goalId: "3", taskName: "Presentation", start: "20:00", duration: 60, distraction: 1, status: true) */
        
 
        checkGoalData()
        checkTaskData()
        
        
        // Collection View related things - Michael
        setupCollectionViewCell()
        collectionView.backgroundColor = UIColor.clear
    }
    
    @IBAction func myUnwindAction(unwindSegue:UIStoryboardSegue)
    {
        
    }
    
    func showDate()
    {
        let todayDate = Date()
        dateFormat1.dateFormat = "dd/MM/yy"
        dateFormat2.dateFormat = "dd MMM yyyy"
        dateString = dateFormat1.string(from: todayDate)
        dateString2 = dateFormat2.string(from: todayDate)
        
        dateLabel.text = dateString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReportViewController
        {
            destination.tempDate = dateString2
            destination.tempDate2 = dateString
            
            
        }
    }
    
    func updateDateData(entity: String, uniqueId: String, newDate: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueId)
        
        do{
            let fetch = try managedContext.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            
            if entity == "Goal" {
                dataToUpdate.setValue(newDate, forKey: "date")
            } else if entity == "Task" {
                dataToUpdate.setValue(newDate, forKey: "status")
            }
            
            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
    
    func storeDataToGoal(entity: String , name: String, status: BooleanLiteralType) {
        
        // get today's date in string
        let todayDate = Date()
        dateFormat1.dateFormat = "dd/MM/yy"
        dateString = dateFormat1.string(from: todayDate)
        print(dateString)
        
        // retrieve id
        var id = "0"
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let context1 = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        var countingRow : Int = 0
        
        do {
            let result = try context1.fetch(fetch)
            for data in result as! [NSManagedObject] {
                goalIdArray.append(data.value(forKey: "id") as! String)
                print("goal id array : \(goalIdArray)")
                
                countingRow = countingRow + 1
                print("Goal table row \(countingRow)")
                print("Id = \(data.value(forKey: "id"))")
                
                id = "\(data.value(forKey: "id")!)"
                var tempId: Int = Int(id)!
                tempId = tempId + 1
                id = "\(tempId)"
//                print("name = \( data.value(forKey: "goalName"))")
//                print("date = \(data.value(forKey: "date"))")
//                print(data.value(forKey: "status"))
            }
        } catch {
            print("Failed")
        }
        print("Total number of row in goals: \(countingRow)")
        
        print("id is \(id)")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext

        let dataOfEntity = NSEntityDescription.entity(forEntityName: entity, in: context)!

        let listOfEntity = NSManagedObject(entity: dataOfEntity, insertInto: context)

        if entity == "Goal" {

            listOfEntity.setValue(id, forKey: "id")
            listOfEntity.setValue(name, forKey: "goalName")
            listOfEntity.setValue(dateString, forKey: "date")
            listOfEntity.setValue(status, forKey: "status")
        }

        do {

            try context.save()
            print("Success save data")

        } catch let error as NSError {

            print("Gagal save context \(error), \(error.userInfo)")

        }
    }

    func storeDataToTask(entity: String, id: String, goalId: String, taskName:String, start:String, duration: Int, distraction: Int, status: BooleanLiteralType) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext

        let dataOfEntity = NSEntityDescription.entity(forEntityName: entity, in: context)!

        let listOfEntity = NSManagedObject(entity: dataOfEntity, insertInto: context)

         if entity == "Task" {
            
            listOfEntity.setValue(id, forKey: "id")
            listOfEntity.setValue(goalId, forKey: "goalId")
            listOfEntity.setValue(taskName, forKey: "taskName")
            listOfEntity.setValue(start, forKey: "start")
            listOfEntity.setValue(duration, forKey: "duration")
            listOfEntity.setValue(distraction, forKey: "distraction")
            listOfEntity.setValue(status, forKey: "status")
        
        }

        do {
            
           try context.save()
           print("Success save data")
        
        } catch let error as NSError {
           
            print("Gagal save context \(error), \(error.userInfo)")
        
        }
    }
    
    
    
    
    func checkDataTopic() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDel.persistentContainer.viewContext
        var countingRow : Int = 0 //menghitung jumlah baris yang ada
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        var countingDuration : Int = 0
        
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                countingRow = countingRow + 1
                let duration: Int = data.value(forKey: "duration") as! Int
                countingDuration += duration
            }
        } catch {
            print("Failed")
        }
        
        print(countingDuration)
        print(countingRow)
    }
    
    func checkGoalData() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        var countingRow : Int = 0
        
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                goalIdArray.append(data.value(forKey: "id") as! String)
                print("goal id array : \(goalIdArray)")
                
                countingRow = countingRow + 1
                print("Goal table row \(countingRow)")
                print("Id = \(data.value(forKey: "id"))")
                print("name = \( data.value(forKey: "goalName"))")
                print("date = \(data.value(forKey: "date"))")
                print(data.value(forKey: "status"))
            }
        } catch {
            print("Failed")
        }
        print("Total number of row in goals: \(countingRow)")
    }
    
    func checkTaskData() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        var countingRow : Int = 0
        
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                countingRow = countingRow + 1
                print("Task table row \(countingRow)")
                print("Id = \(data.value(forKey: "id"))")
                print("goalid = \( data.value(forKey: "goalId"))")
                print("task name= \(data.value(forKey: "taskName"))")
                print(" start = \(data.value(forKey: "start"))")
                 print(" duration = \(data.value(forKey: "duration"))")
                 print(" distraction = \(data.value(forKey: "distraction"))")
                 print((data.value(forKey: "status") as! BooleanLiteralType))
            }
        } catch {
            print("Failed")
        }
        print("Total number of row in goals: \(countingRow)")
    }
    
    
    
    func deleteGoalData(entity: String, uniqueId: String) {
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
    
    func deleteTaskData(entity: String, uniqueId: String) {
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
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return taskPerGoals[
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    
}

// Michael - Collection View is extended here
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    struct goalStruct {
        var goalId: String
        var goalName: String
        var goalDate: String
        var goalStatus: Any
    }
    // to register the nib files of collection cells
    func setupCollectionViewCell(){
        collectionView.register(UINib(nibName: "GoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "goalCollectionViewCell")
        collectionView.register(UINib(nibName: "NewGoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newGoalCollectionViewCell")
    }
    
    // function to find the total number of goals for today
    func findNumberOfGoalsToday() -> Int {
    
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        var countingRow : Int = 0
        
        // number of Goals for today
        var numberOfGoalsForToday: Int = 0
        
        // finding today's date in proper string format
        let todayDate = Date()
        dateFormat1.dateFormat = "dd/MM/yy"
        dateString = dateFormat1.string(from: todayDate)
        print(dateString)
        
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                countingRow = countingRow + 1
                print("Goal table row \(countingRow)")
                print(data.value(forKey: "id") as! String)
                print(data.value(forKey: "goalName") as! String)
                print(data.value(forKey: "date") as! String)
                print(data.value(forKey: "status") as! boolean_t)
                let dataDate = (data.value(forKey: "date") as! String)
                
                // compare the retrieved data with today's date
                if (dataDate == dateString){
                    numberOfGoalsForToday += 1
                }
            }
        } catch {
            print("Failed")
        }
        print("Total number of row : \(countingRow)")
        
        // if for some reason there is more than 3 goals for today, it still only returns 3 to prevent extra cells
        if (numberOfGoalsForToday > 3){
            numberOfGoalsForToday = 3
        }
        print(numberOfGoalsForToday)
        return numberOfGoalsForToday
    }
    
    // this function determines if another goal can be added for today
    func canAddGoal() -> Bool {
        
        // if the number of goals is not 3, we can still add a new goal
        if (findNumberOfGoalsToday() < 3){
            return true
        }
        return false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // for each goals a cell will be created with template GoalCollectionViewCell
        // for the add goals, a cell will be created with template NewGoalCollectionViewCell
        
        // index at where the add cell is used
        let addFlag = findNumberOfGoalsToday()
        let goalsArray = retrieveTodayGoalData()
        var currentGoal: goalStruct?
        
        print(currentGoal?.goalId)
        
        currentGoal = nil
        
        if (!goalsArray.isEmpty && indexPath.row < addFlag){
            currentGoal = goalsArray[indexPath.row]
        }
        
        // before addFlag returns the goal cell
        if(indexPath.row < addFlag ){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell
            cell.layer.cornerRadius = 8
            cell.goalLabel.text = currentGoal!.goalName
            print("cell 1")
            return cell
        } // after addFlag returns the add cell
        else{ // which is - if(indexPath.row >= addFlag)
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "newGoalCollectionViewCell", for: indexPath) as! NewGoalCollectionViewCell
            cell2.layer.cornerRadius = 8
            print("Cell 2")
            return cell2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // index at where the add cell is used
        let addFlag = findNumberOfGoalsToday()
        
        // if selected a goal cell
        if(indexPath.row < addFlag){
            
        }
        // if selected an add goal cell
        else{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "NewGoalViewController")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "newGoalViewController") as! NewGoalViewController
//            let vc = NewGoalViewController()
            vc.delegate = self
            self.present(vc, animated: true)
            
        }
    }
    
    func reloadCollection(){
        collectionView.reloadData()
    }
    
    // returns an array of today's goals
    func retrieveTodayGoalData() -> [goalStruct] {
        var goalsArray: [goalStruct]
        goalsArray = []
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        var countingRow : Int = 0
        
        let todayDate = Date()
        dateFormat1.dateFormat = "dd/MM/yy"
        dateString = dateFormat1.string(from: todayDate)
        print(dateString)
        
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                let currentDate = "\(data.value(forKey: "date")!)"
                if (currentDate == dateString){ // if data is goal for today's date
                    // put in a temporary goalStruct
                    let tempGoal = goalStruct(
                        goalId: "\(data.value(forKey: "id")!)",
                        goalName: "\( data.value(forKey: "goalName")!)",
                        goalDate: "\(data.value(forKey: "date")!)",
                        goalStatus: data.value(forKey: "status")!)
                    
                    // append the goalStruct to the array
                    goalsArray.append(tempGoal)
                }
                
                
                
                countingRow = countingRow + 1
                print("Goal table row \(countingRow)")
                print("Id = \(data.value(forKey: "id"))")
                print("name = \( data.value(forKey: "goalName"))")
                print("date = \(data.value(forKey: "date"))")
                print(data.value(forKey: "status"))
                
                
                
            }
        } catch {
            print("Failed")
        }
        print("Total number of row in goals: \(countingRow)")
        return goalsArray
    }
    
}


