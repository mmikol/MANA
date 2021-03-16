//
//  HomeViewController.swift
//  MANA
//
//  Created by Miliano Mikol on 1/31/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITabBarControllerDelegate {
    let database = Firestore.firestore()
    let numberFormatter = NumberFormatter()

    @IBOutlet weak var bestBenchLabel: UILabel!
    @IBOutlet weak var bestSquatLabel: UILabel!
    @IBOutlet weak var bestDeadliftLabel: UILabel!
   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         let tabBarIndex = tabBarController.selectedIndex
         if tabBarIndex == 0 {
            showPersonalBests()
         }
    }

    // REMOVE HARD CODE AFTER TESTS
    private func showPersonalBests() {
        if let user = Auth.auth().currentUser {
            let documentReference = database.collection("users").document("K3nMnBjnrMcXndZ5Q5RWjVEVuZo2")
            
            documentReference.getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let bestBench = data!["best_bench"] as? String ?? "0"
                    let bestSquat = data!["best_squat"] as? String ?? "0"
                    let bestDeadlift = data!["best_deadlift"] as? String ?? "0"
                    let bestBenchString = self.numberFormatter.string(from: NSNumber(value: Int(bestBench) ?? 0))
                    let bestSquatString = self.numberFormatter.string(from: NSNumber(value: Int(bestSquat) ?? 0))
                    let bestDeadliftString = self.numberFormatter.string(from: NSNumber(value: Int(bestDeadlift) ?? 0))
                    self.bestBenchLabel.text = "\(bestBenchString!) \nlbs"
                    self.bestSquatLabel.text = "\(bestSquatString!) \nlbs"
                    self.bestDeadliftLabel.text = "\(bestDeadliftString!) \nlbs"
                  } else {
                     print("Document does not exist")
                  }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .decimal
        showPersonalBests()
        self.tabBarController?.delegate = self
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
