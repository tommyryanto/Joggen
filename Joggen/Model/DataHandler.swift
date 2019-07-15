//
//  DataHandler.swift
//  Joggen
//
//  Created by Tommy Ryanto on 12/07/19.
//  Copyright © 2019 Tommy Ryanto. All rights reserved.
//

import UIKit
import CoreData

class DataHandler {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        return appDel.persistentContainer.viewContext
    }
    
    class func saveTarget(date: Date, distance: Float, session_per_week: Int32, duration: Int32, id: Int16, session_count: Int32) {
        let context = getContext()
        
        let target = Target(context: context)
        target.date = date
        target.distance = distance
        target.session_per_week = session_per_week
        target.duration = duration
        target.id = id
        
        let week = Weeks(context: context)
        week.id = id
        week.session_count = session_count
        week.date_start = date
        
        target.week = week
        
        //masih error
        /*
        if let week = target.week {
            week.id = id
            week.session_count = session_count
            week.date_start = date
        }*/
        
        do {
            try context.save()
            print("goal data added")
        } catch {
            print("goal data failed")
        }
    }
    
    class func saveAchived(calories: Int32, duration: Int32, id: Int16, jog_interval: Int32, walk_interval: Int32, distance: Float, session_count: Int32, date_start: Date) {
        let context = getContext()
        
        let achived = Achived(context: context)
        achived.calories = calories
        achived.duration = duration
        achived.id = id
        achived.jog_interval = jog_interval
        achived.walk_interval = walk_interval
        achived.distance = distance
        
        let week = Weeks(context: context)
        week.id = id
        week.session_count = session_count
        week.date_start = date_start
        
        achived.week = week
        
        /*
        achived.week?.id = id
        achived.week?.session_count = session_count
        achived.week?.date_start = date_start*/
        
        do {
            try context.save()
            print("achive data added")
        } catch {
            print("achive data failed")
        }
    }
    
    class func retrieveTarget() -> [Target]? {
        var target: [Target]?
        
        do {
            target = try getContext().fetch(Target.fetchRequest())
            print("retrieved \((target?.count)!) target data success")
            return target
        } catch {
            print("retrieved target data failed")
            return nil
        }
    }
    
    class func retrieveAchived() -> [Achived]? {
        let achived: [Achived]?
        
        do {
            achived = try getContext().fetch(Achived.fetchRequest())
            print("retrieved \((achived?.count)!) achived data success")
            return achived
        } catch {
            print("retrieved achived data failed")
            return nil
        }
    }
    
}
