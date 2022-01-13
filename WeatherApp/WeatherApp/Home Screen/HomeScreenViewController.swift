//
//  HomeScreenViewController.swift
//  WeatherApp
//
//  Created by Adriaan van Schalkwyk on 2022/01/13.
//

import UIKit

class HomeScreenViewController: UIViewController {
 
    @IBOutlet public var weatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableViewCell()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
    }
    
    private func setupTableViewCell() {
        self.weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main),
                                forCellReuseIdentifier: "WeatherTableViewCell")
        
        self.weatherTableView.register(UINib(nibName: "WeatherTableViewHeaderCell", bundle: Bundle.main),
                                forCellReuseIdentifier: "WeatherTableViewHeaderCell")
    }
    
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewHeaderCell") as! WeatherTableViewHeaderCell
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
