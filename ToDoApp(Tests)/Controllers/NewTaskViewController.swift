//
//  NewTaskViewController.swift
//  ToDoApp(Tests)
//
//  Created by Данил Прокопенко on 15.11.2022.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {

    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    //ToDo: Safety check
   
    
    @IBAction func save() {
        let titleString = titleTextField.text
        let LocationString = locationTextField.text
        let date = dateFormatter.date(from: dateTextField.text!)
        let descriptionString = descriptionTextField.text
        let addressString = addressTextField.text
        geocoder.geocodeAddressString(addressString!) { [unowned self] (placemarks, error) in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: LocationString!, coordinate: coordinate)
            
            let task = Task(title: titleString!, description: descriptionString, date: date, location: location)
            self.taskManager.add(task: task)
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    //ToTest
    @IBAction func cancel() {
        dismiss(animated: true)
    }
    
    
    
}
