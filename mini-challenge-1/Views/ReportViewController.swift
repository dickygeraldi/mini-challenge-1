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
    var countingDuration : Int = 0
    var countingTaskDistracted : Int = 0
    var tempDate2 = "" //untuk mengambil data dari format dateString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        //method buat ambil data dari coredata
        checkGoalData()
        checkTaskData()
        
        //set label yang ada di UI
        totalGoalsCompletedLabel.text = "\(countingRow)"
        totalTaskCompletedLabel.text = "\(countingTaskRow)"
        totalProductiveMinsLabel.text = "\(countingDuration)"
        totalTimesDistractedLabel.text = "\(countingTaskDistracted)"
        
        dateLabel.text = tempDate
        
        self.navigationController?.isNavigationBarHidden = true //untuk hilangin navigation bar
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
             print(data.value(forKey: "status") as! boolean_t)
                
                // jadi untuk goal yang kehitung tu yang hanya hari ini aja
                if(data.value(forKey: "date") as! String == tempDate2)
                {
                    countingRow = countingRow + 1
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
