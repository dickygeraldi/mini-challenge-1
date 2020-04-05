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

        checkGoalData()
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
                    

                   }
        }
        
    }

func storeGoalData()
       {
        //memasukkan data ke table goal
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

           let context = appDelegate.persistentContainer.viewContext
           
           let messageEntity = NSEntityDescription.entity(forEntityName: "Goal", in: context)!
           
           let listMessage = NSManagedObject(entity: messageEntity, insertInto: context)
           
           listMessage.setValue("G001", forKey: "id")
           listMessage.setValue("Do Homework", forKey: "goalName")
           listMessage.setValue("05/04/2020", forKey: "date") //masih belum bisa simpen nilai dari tanggal sekarang(variable dateString),saat dimasukin, gtw kenapa masih eror. padahal udah bisa ngambil data secara otomatis buat sekarang
           listMessage.setValue(1, forKey: "status")
           
           do {
               try context.save()
               print("Success save data")
           } catch let error as NSError
           {
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
    
    func storeDataMessage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext
        
        let messageEntity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        
        let listMessage = NSManagedObject(entity: messageEntity, insertInto: context)
        
        listMessage.setValue("id", forKey: "id")
        listMessage.setValue("GoalsId", forKey: "goalId")
        listMessage.setValue("taskName", forKey: "taskName")
        listMessage.setValue("start", forKey: "start")
        listMessage.setValue(60, forKey: "duration")
        listMessage.setValue(60, forKey: "distraction")
        listMessage.setValue(true, forKey: "status")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Gagal save context \(error), \(error.userInfo)")
        }
        
       
}




