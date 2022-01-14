//
//  FavouriteLocationsViewController.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/14.
//

import UIKit

class FavouriteLocationsViewController: UITableViewController {
        
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private lazy var viewModel = FavouriteLocationsViewModel(delegate: self,
                                                             context: context,
                                                             interactor: WeatherInformationInteractor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // startLoadindAnimation()
        viewModel.loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell
        cell.textLabel?.text = viewModel.dataList[indexPath.row].name
        return cell
    }
    
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Favourite location", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Location", style: .default) { (action) in
            self.viewModel.fetchWeatherData(cityName: textField.text ?? "")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Location"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func startLoadindAnimation() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}


extension FavouriteLocationsViewController: CoreDataManagerDelegate {
    
    func errorHandler() {
        
    }
    
    func didfetchData(ID: Int, cityName: String) {
        viewModel.saveData(ID, cityName: cityName)
    }
    
    func didUpdateData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
//            if self.viewModel.dataList.isEmpty {
//
//            }
            self.tableView.reloadData()
       }
    }
}
