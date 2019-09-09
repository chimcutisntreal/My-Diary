import Foundation
import CoreData
import UIKit
import FSCalendar

class DiaryData: UIAlertController,FSCalendarDelegate {
    
    func save(inputTitle: String, inputBodyText: String, createdAt: String, inputImage: Data?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let  entityName = NSEntityDescription.entity(forEntityName: "Diary", in: managedContext)
        let newDiary  = NSManagedObject(entity: entityName!, insertInto: managedContext)
        
        newDiary.setValue(inputTitle, forKeyPath: "diaryTitle")
        newDiary.setValue(inputBodyText, forKeyPath: "diaryBodyText")
        newDiary.setValue(createdAt, forKeyPath: "diaryDateTime")
        newDiary.setValue(inputImage, forKey: "diaryImage")
        do {
            try managedContext.save()
        
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func showAllData() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
//        let sortDescriptor = NSSortDescriptor(key: "diaryDateTime", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        fetchRequest.fetchLimit = 1
        
        do {
            let result = try managedContext.fetch(fetchRequest)

            return result
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return [NSManagedObject]()
    }
    
    func showDataByDate(selectedDate: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
        fetchRequest.predicate = NSPredicate(format: "diaryDateTime contains[c] '\(selectedDate)'")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            return result
            }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return [NSManagedObject]()
    }
    
    func deleteObject(obj: NSManagedObject) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            managedContext.delete(obj)
            try managedContext.save()
            return true
        }
        catch {
            print("delete fail")
        }
        return false
    }
}
    
    

