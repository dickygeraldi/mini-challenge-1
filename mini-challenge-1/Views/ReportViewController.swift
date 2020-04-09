//
//  ReportViewController.swift
//  mini-challenge-1
//
//  Created by Nathanael Adolf Sukiman on 04/04/20.
//  Copyright © 2020 Dicky Geraldi. All rights reserved.
//

import UIKit
import CoreData

class ReportViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalGoalsCompletedLabel: UILabel!
    @IBOutlet weak var totalTaskCompletedLabel: UILabel!
    @IBOutlet weak var totalProductiveMinsLabel: UILabel!
    @IBOutlet weak var totalTimesDistractedLabel: UILabel!
    
    var countingRow : Int = 0
    var tempDate = ""
    var countingTaskRow : Int = 0
    var tempDate2 = "" //untuk mengambil data dari format dateString
    
    var countingGoalRow = 0
    var goalFlag = 1
    var countingDuration = 0
    var countingDistracted = 0
    
    var goalIdArray : [String] = []
    var falseGoalIdArray : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        //method buat ambil data dari coredata
        checkGoalData()
        checkTaskData()
        checkGoalData()
        
        //set label yang ada di UI
        //totalGoalsCompletedLabel.text = "\(countingGoalRow)" //set di func checkGoalData biar datanya valid
        totalTaskCompletedLabel.text = "\(countingTaskRow)"
        totalProductiveMinsLabel.text = "\(countingDuration)"
        totalTimesDistractedLabel.text = "\(countingDistracted)"
        
        dateLabel.text = tempDate
        
        self.navigationController?.isNavigationBarHidden = true //untuk hilangin navigation bar
    }
    
   
    func checkGoalData() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        countingGoalRow = 0
        
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
            
            goalIdArray.append(data.value(forKey: "id") as! String)
                
             print("Goal table row \(countingGoalRow)")
             print(data.value(forKey: "id") as! String)
             print(data.value(forKey: "goalName") as! String)
             print(data.value(forKey: "date") as! String)
             print(data.value(forKey: "status") as! Bool)
                
                // jadi untuk goal yang kehitung tu yang hanya hari ini aja
                if(data.value(forKey: "date") as! String == tempDate2)
                {
                    print("sddsfasdf")
                    if(data.value(forKey: "status") as! Bool == true)
                    {
                        print("true goal counted")
                        countingGoalRow = countingGoalRow + 1
                    }
                }
                
                if(data.value(forKey: "status") as! Bool == false)//==0 artinya false
                               {
                                   
                               }
            }
        } catch {
            print("Failed")
        }
        totalGoalsCompletedLabel.text = "\(countingGoalRow)"
     print("Total number of row : \(countingGoalRow)")
    }
    
    func checkTaskData() {
           guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
           let context = appDel.persistentContainer.viewContext
            countingTaskRow = 0 //menghitung jumlah baris yang ada
            countingDuration = 0 //menghitung jumlah waktu produktif
            countingDistracted = 0
            goalFlag = 1
        
           let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
           
           do {
               let result = try context.fetch(fetch)
               for data in result as! [NSManagedObject]
               {
                    for i in 0..<goalIdArray.count {
                        if(data.value(forKey: "goalId") as! String == goalIdArray[i] && data.value(forKey: "status") as! Bool == true )
                        {
                            print("counting task row counted")
                            
                            countingTaskRow = countingTaskRow + 1
                            countingDuration += data.value(forKey: "duration") as! Int
                            countingDistracted += data.value(forKey: "distraction") as! Int
                            
                           
                        }
                        else if(data.value(forKey: "goalId") as! String == goalIdArray[i] && data.value(forKey: "status") as! Bool == false)
                        {
                            falseGoalIdArray.append(data.value(forKey: "goalId")as! String)
                            goalFlag = 0
                        }
                    }
                       
                    
                  
                }
           } catch {
               print("Failed")
           }
        
        for i in 0..<goalIdArray.count {
            updateGoalStatusData(entity: "Goal", uniqueId: goalIdArray[i], newStatus: true)
        }
        
        for i in 0..<falseGoalIdArray.count {
                   updateGoalStatusData(entity: "Goal", uniqueId: falseGoalIdArray[i], newStatus: false)
               }
        
            
            print(countingDuration)
            print(countingTaskRow)
            print(countingDistracted)
        
       }
    
    func updateGoalStatusData(entity: String, uniqueId: String, newStatus: Bool) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
           fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueId)
           
           do{
               let fetch = try managedContext.fetch(fetchRequest)
               let dataToUpdate = fetch[0] as! NSManagedObject
               
               if entity == "Goal" {
                   dataToUpdate.setValue(newStatus, forKey: "status")
               } else if entity == "Task" {
                   dataToUpdate.setValue(newStatus, forKey: "status")
               }
               
               try managedContext.save()
           }catch let err{
               print(err)
           }
       }
    
    @IBAction func saveReflectionAction(_ sender: Any) {
        showAlert()
    }
    
    func showAlert() {
               let alert = UIAlertController(title: "Message", message: "Reflection Saved", preferredStyle: .alert)
               let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
               alert.addAction(action)
               self.present(alert, animated: true, completion: nil)
           }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController
{

    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEditingKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func endEditingKeyboard()
    {
        view.endEditing(true)
    }
}
