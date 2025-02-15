//
//  AddWorkoutViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 2/14/21.
//
import UIKit
import OSLog

class AddWorkoutViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var liftTypeLabel: UILabel!
    @IBOutlet weak var benchButton: UIButton!
    @IBOutlet weak var squatButton: UIButton!
    @IBOutlet weak var deadliftButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var workout: Workout?
    var workoutData: WorkoutData?
    var dateInput = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextField.delegate = self
        datePicker.backgroundColor = .white

        // Set up views if editing an existing Workout.
        if let workout = workout {
            weightTextField.text = workout.weight!
            datePicker.date = workout.date!
            
            switch(workout.name) {
            case "Bench Press":
                benchButton.isSelected = true
                benchButton.setImage(UIImage(named: "benchWithSquare"), for: .normal)
                lowerView.backgroundColor = #colorLiteral(red: 0.9883286357, green: 0.7884005904, blue: 0, alpha: 1)
            case "Squat":
                squatButton.isSelected = true
                squatButton.setImage(UIImage(named: "squatWithSquare"), for: .normal)
                lowerView.backgroundColor = #colorLiteral(red: 0.08806554228, green: 0.5374518037, blue: 0.789417088, alpha: 1)
            case "Deadlift":
                deadliftButton.isSelected = true
                deadliftButton.setImage(UIImage(named: "deadliftWithSquare"), for: .normal)
                lowerView.backgroundColor = #colorLiteral(red: 0.9852438569, green: 0, blue: 0, alpha: 1)
            default:
                break
            }
        }
        
        // Enable the Save button only if inputs are given.
        updateSaveButtonState()
    }
    
    @IBAction func cancel(_ sender: Any) {
        let isPresentingInAddWorkoutMode = self.presentingViewController != nil
        
        if isPresentingInAddWorkoutMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The AddWorkoutViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func benchButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }

        guard benchButton.isSelected else {
            benchButton.isSelected = true
            benchButton.setImage(UIImage(named: "benchWithSquare"), for: .normal)
            lowerView.backgroundColor = #colorLiteral(red: 0.9883286357, green: 0.7884005904, blue: 0, alpha: 1)
            if squatButton.isSelected {
                squatButton.isSelected = false
                squatButton.setImage(UIImage(named: "squat"), for: .normal)
            } else if deadliftButton.isSelected {
                deadliftButton.isSelected = false
                deadliftButton.setImage(UIImage(named: "deadlift"), for: .normal)
            }
            updateSaveButtonState()
            return
        }
    }
    
    @IBAction func squatButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }

        guard squatButton.isSelected else {
            squatButton.isSelected = true
            squatButton.setImage(UIImage(named: "squatWithSquare"), for: .normal)
            lowerView.backgroundColor = #colorLiteral(red: 0.08806554228, green: 0.5374518037, blue: 0.789417088, alpha: 1)
            if benchButton.isSelected {
                benchButton.isSelected = false
                benchButton.setImage(UIImage(named: "bench"), for: .normal)
            } else if deadliftButton.isSelected {
                deadliftButton.isSelected = false
                deadliftButton.setImage(UIImage(named: "deadlift"), for: .normal)
            }
            updateSaveButtonState()
            return
        }
    }
    
    @IBAction func deadliftButtonTapped(_ sender: Any) {
        if let button = (sender as? UIButton){
            button.showAnimation{}
        }

        guard deadliftButton.isSelected else {
            deadliftButton.isSelected = true
            deadliftButton.setImage(UIImage(named: "deadliftWithSquare"), for: .normal)
            lowerView.backgroundColor = #colorLiteral(red: 0.9852438569, green: 0, blue: 0, alpha: 1)
            if benchButton.isSelected {
                benchButton.isSelected = false
                benchButton.setImage(UIImage(named: "bench"), for: .normal)
            } else if squatButton.isSelected {
                squatButton.isSelected = false
                squatButton.setImage(UIImage(named: "squat"), for: .normal)
            }
            updateSaveButtonState()
            return
        }
    }
 
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.dateInput = sender.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let nameInput = (benchButton.isSelected ? "Bench Press" :
                    squatButton.isSelected ? "Squat" :
                    deadliftButton.isSelected ? "Deadlift" : "")
        let weightInput = weightTextField.text ?? ""

        self.workoutData = WorkoutData(name: nameInput, weight: weightInput, date: dateInput)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }

    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        if benchButton.isSelected || squatButton.isSelected || deadliftButton.isSelected {
            let weightText = weightTextField.text ?? ""
            saveButton.isEnabled = !weightText.isEmpty
        } else {
            saveButton.isEnabled = false
        }
    }
}
