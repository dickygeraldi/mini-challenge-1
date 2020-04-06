//
//  ViewController.swift
//  mini-challenge-1
//
//  Created by Dicky Geraldi on 03/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dateFormat1: DateFormatter = DateFormatter ()
    var dateString : String = ""
    var dateString2 : String = "" //untuk format date yang beda di halaman Report
    let dateFormat2: DateFormatter = DateFormatter ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        
        self.navigationController?.isNavigationBarHidden = true //untuk hilangin navigation bar
        showDate()//untuk set dateLabel jadi tanggal hari ini
        
        //storeDataToGoal(entity: "Goal") hanya untuk cek
        checkGoalData()
        
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
    
    
    func storeDataToGoal(entity: String) {

           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

           let context = appDelegate.persistentContainer.viewContext

           let dataOfEntity = NSEntityDescription.entity(forEntityName: entity, in: context)!

           let listOfEntity = NSManagedObject(entity: dataOfEntity, insertInto: context)

           if entity == "Goal" {
               
               listOfEntity.setValue("2", forKey: "id")
               listOfEntity.setValue("Wireframe", forKey: "goalName")
               listOfEntity.setValue("\(dateString)", forKey: "date")
               listOfEntity.setValue(0, forKey: "status")
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
                countingRow = countingRow + 1
                print("Goal table row \(countingRow)")
                print(data.value(forKey: "id") as! String)
                print(data.value(forKey: "goalName") as! String)
                print(data.value(forKey: "date") as! String)
                print(data.value(forKey: "status") as! boolean_t)
            }
        } catch {
            print("Failed")
        }
        print("Total number of row : \(countingRow)")
    }
    
    
   

    
    
}

// Michael - Collection View is extended here
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
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
                if (dataDate == ""){
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
//        return 3
        // the number of cells will be number of goals for today and an extra to create a new one if there is still space
        if canAddGoal(){
            return findNumberOfGoalsToday() + 1
        }
        // if no more goals can be added today
        return findNumberOfGoalsToday()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // for each goals a cell will be created with template GoalCollectionViewCell
        // for the add goals, a cell will be created with template NewGoalCollectionViewCell
//        let numberOfGoals = 2
//        let canAddGoals = true
        let numberOfGoals = findNumberOfGoalsToday()
        let canAddGoals = canAddGoal()
        
        if canAddGoals{
            if (indexPath.row == numberOfGoals){
                let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "newGoalCollectionViewCell", for: indexPath) as! NewGoalCollectionViewCell
                cell2.layer.cornerRadius = 8
                return cell2
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell
        cell.layer.cornerRadius = 8
        return cell
    }
    
    
}


