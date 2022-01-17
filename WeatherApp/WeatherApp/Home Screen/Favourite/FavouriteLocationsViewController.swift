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
        startLoadindAnimation()
        viewModel.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        let favouriteDetailsViewController = segue.destination as! FavouriteDetailsViewController
        favouriteDetailsViewController.weatherData = viewModel.weatherData
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(viewModel.dataList.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if viewModel.dataList.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "NoFavouritesTableViewCell", for: indexPath)
            cell.textLabel?.text = "Start adding favourites" 
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell
            cell.textLabel?.text = viewModel.dataList[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = viewModel.dataList[indexPath.row].id
            viewModel.deleteData(Int(id))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cityName = viewModel.dataList[indexPath.row].name {
            viewModel.fetchWeatherData(cityName: cityName, shouldSave: false)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Favourite location", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Location", style: .default) { (action) in
            self.viewModel.fetchWeatherData(cityName: textField.text ?? "", shouldSave: true)
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
    
    func didfetchWeatherData() {
        DispatchQueue.main.async {
        self.performSegue(withIdentifier: "WeatherDetailsSegue", sender: self)
        }
    }
    
    func didLoadWeatherData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func didUpdateWeatherData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func errorHandler(message: String) {
        self.activityIndicator.stopAnimating()
        let title = "Error with request"
        let message = message
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            alert.view.accessibilityIdentifier = "errorAlertDialog"
            self.present(alert, animated: true, completion: nil)
        }
    }
}
