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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //storeDataMessage()
        
        self.navigationController?.isNavigationBarHidden = true //untuk hilangin navigation bar
        showDate()//untuk set dateLabel jadi tanggal hari ini
        checkDataTopic()
    }
    
    @IBAction func myUnwindAction(unwindSegue:UIStoryboardSegue)
       {
           
       }
    
    func showDate()
       {
           let todayDate = Date()
           dateFormat1.dateFormat = "dd/MM/yy"
           let dateString = dateFormat1.string(from: todayDate)
           
           dateLabel.text = dateString
       }
    
    func checkDataTopic() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDel.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        var countingDuration : Int = 0
        
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                let duration: Int = data.value(forKey: "duration") as! Int
                countingDuration += duration
            }
        } catch {
            print("Failed")
        }
        
        print(countingDuration)
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
}

