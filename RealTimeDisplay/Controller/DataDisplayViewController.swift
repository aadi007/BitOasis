//
//  DataDisplayViewController.swift
//  RealTimeDisplay
//
//  Created by Aadesh Maheshwari on 1/31/19.
//  Copyright © 2019 Aadesh Maheshwari. All rights reserved.
//

import UIKit
import Starscream
import FirebaseAuth
import Charts

final class DataDisplayViewController: UIViewController, UITextFieldDelegate {
    var viewModel: DataDisplayViewModel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var lineGraphView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DataDisplayViewModel(delegate: self)
        viewModel.connectSocket()
        textfield.delegate = self
        configureNavigationBar()
    }
    func configureNavigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutButtonTapped))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == self.view {
                self.textfield.resignFirstResponder()
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func signOutButtonTapped() {
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (action) in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "loggedInUserId")
                self.navigationController?.popViewController(animated: true)
                self.viewModel.disconnectSocket()
            } catch (let error) {
                print("eror to be displayed \(String(describing: error.localizedDescription))")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func highlightActionButtonTapped(_ sender: UIButton) {
        if let input = textfield.text, !input.isEmpty, let value = Double(input) {
            if value <= 0 {
                viewModel.thresholdValue = -1
            } else {
                viewModel.thresholdValue = value
            }
        } else {
            viewModel.thresholdValue = -1
            let alert = UIAlertController(title: "Alert", message: "Please enter data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        textfield.resignFirstResponder()
    }
}

extension DataDisplayViewController: DataDisplayViewModelDelegate {
    func updateGraph(lineChartData: LineChartData, descriptionText: String) {
        lineGraphView.data = lineChartData
        lineGraphView.chartDescription?.text = descriptionText
    }
    func updateBarGraph(barChartData: BarChartData, descriptionText: String) {
        barChartView.data = barChartData
        barChartView.chartDescription?.text = descriptionText
    }
}
