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
    //var countingDuration : Int = 0
    var countingTaskDistracted : Int = 0
    var tempDate2 = "" //untuk mengambil data dari format dateString
    
    
    var countingTaskCompleted : Int = 0
    var countingGoalRow = 0
    var goalFlag = 1
    var countingDuration = 0
    var countingDistracted = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        //method buat ambil data dari coredata
        //checkGoalData()
        //checkTaskData()
        
        checkAllReportData()
        
        //set label yang ada di UI
        totalGoalsCompletedLabel.text = "\(countingGoalRow)"
        totalTaskCompletedLabel.text = "\(countingTaskCompleted)"
        totalProductiveMinsLabel.text = "\(countingDuration)"
        totalTimesDistractedLabel.text = "\(countingTaskDistracted)"
        
        dateLabel.text = tempDate
        
        self.navigationController?.isNavigationBarHidden = true //untuk hilangin navigation bar
    }
    
    func checkAllReportData()
    {
        
        var tempGoalId: String = ""
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
               let context = appDel.persistentContainer.viewContext
               
               let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
               countingRow = 0
                goalFlag = 1
        countingTaskCompleted = 0
        countingDuration = 0
            
               do {
                   let result = try context.fetch(fetch)
                   for data1 in result as! [NSManagedObject] {
                       
                       // jadi untuk goal yang kehitung tu yang hanya hari ini aja
                       if(data1.value(forKey: "date") as! String == tempDate2)
                       {
                            tempGoalId = data1.value(forKey: "id") as! String
                            print(tempGoalId)
                            guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
                                      let context = appDel.persistentContainer.viewContext
                                    let fetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
                                      do {
                                          let result = try context.fetch(fetch1)
                                          for data in result as! [NSManagedObject]
                                          {
                                            
                                            if(data.value(forKey: "id")as! String == tempGoalId)
                                              {
                                                if(data.value(forKey: "status") as! BooleanLiteralType == false)
                                                {
                                                    print("data yang keanggap false : \(data.value(forKey: "taskName")as! String)")
                                                    goalFlag = 0 //bearti goalnya belum complete
                                                    updateStatusData(entity: "Goal", uniqueId: tempGoalId, newData: 0)
                                                }
                                                else{
                                                    //hitung task yang ada
                                                    print("data yang dianggap true: \(data.value(forKey: "taskName")as! String)")
                                                    countingTaskCompleted += 1
                                                    countingDuration += data.value(forKey: "duration") as! Int
                                                    
                                                }
                                              }
                                          }
                                      } catch
                                      {
                                          print("Failed")
                                      }
                                  
                           countingRow = countingRow + 1
                       }
                    
                    if(goalFlag == 1)
                    {
                        updateStatusData(entity: "Goal", uniqueId: tempGoalId, newData: 1)
                        countingGoalRow += 1
                    }
                       
                       /*if(data.value(forKey: "status") as! boolean_t == 0)//==0 artinya false
                                      {
                                          print("false goals")
                                      }*/
                   }
               } catch {
                   print("Failed")
               }
            print("Total number of row : \(countingRow)")
           
    }
    
    func checkGoalData() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        countingRow = 0
     
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
            
             print("Goal table row \(countingRow)")
             print(data.value(forKey: "id") as! String)
             print(data.value(forKey: "goalName") as! String)
             print(data.value(forKey: "date") as! String)
             print(data.value(forKey: "status") as! Bool)
                
                // jadi untuk goal yang kehitung tu yang hanya hari ini aja
                if(data.value(forKey: "date") as! String == tempDate2)
                {
                    countingRow = countingRow + 1
                }
                
                if(data.value(forKey: "status") as! boolean_t == 0)//==0 artinya false
                               {
                                   print("false goals")
                               }
            }
        } catch {
            print("Failed")
        }
     print("Total number of row : \(countingRow)")
    }
    
    func checkTaskData() {
           guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
           let context = appDel.persistentContainer.viewContext
            countingTaskRow = 0 //menghitung jumlah baris yang ada
            countingTaskDistracted = 0 //menghitung jumlah berapa kali ke distract yang ada
            countingDuration = 0 //menghitung jumlah waktu produktif
        
           let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
           
           do {
               let result = try context.fetch(fetch)
               for data in result as! [NSManagedObject] {
                   countingTaskRow = countingTaskRow + 1
                   let duration: Int = data.value(forKey: "duration") as! Int
                  let timesDistracted: Int = data.value(forKey: "distraction") as! Int
                
                   countingDuration += duration
                countingTaskDistracted += timesDistracted
               }
           } catch {
               print("Failed")
           }
           
            print(countingDuration)
            print(countingTaskRow)
            print(countingTaskDistracted)
       }
    
    func updateStatusData(entity: String, uniqueId: String, newData: boolean_t) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entity)
           fetchRequest.predicate = NSPredicate(format: "id = %@", uniqueId)
           
           do{
               let fetch = try managedContext.fetch(fetchRequest)
               let dataToUpdate = fetch[0] as! NSManagedObject
               
               if entity == "Goal" {
                   dataToUpdate.setValue(newData, forKey: "status")
               } else if entity == "Task" {
                   dataToUpdate.setValue(newData, forKey: "status")
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
