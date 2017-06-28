//
//  StepDisplayViewController.swift
//  TenDayStepCounter
//
//  Created by Zach Lockett-Streiff on 6/26/17.
//  Copyright © 2017 Swingaroo2. All rights reserved.
//

import UIKit

class StepDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView?
    
    let motionService = MotionService()
    let dispatchGroup = DispatchGroup()
    
    struct Constants {
        static let numPreviousDays = 10
        static let cellNibName = "StepDisplayTableViewCell"
        static let cellReuseId = "StepDisplayCell"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Note: use simulated data for unsupported devices
        // Check if current device is supported
        
        self.setUpTableView()
        
        self.motionService.getDailyStepDataUntilToday(numberOfDays: Constants.numPreviousDays, dispatchGroup: self.dispatchGroup)
        
        self.dispatchGroup.notify(queue: DispatchQueue.main, execute:{ [weak self] in
            self?.tableView?.tableFooterView = UIView()
            self?.tableView?.delegate = self
            self?.tableView?.dataSource = self
            self?.tableView?.reloadData()
        })
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Selected row at index path: \(indexPath)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Would localize string if I had the resources for it
        return "Steps"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Constants.numPreviousDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId) as! StepDisplayTableViewCell
        let data = self.motionService.dataArr[indexPath.row]
        cell.configureCellWithData(data)
        return cell
    }
    
    // MARK: - Helpers
    func setUpTableView()
    {
        let cellNib = UINib(nibName: Constants.cellNibName, bundle: Bundle.main)
        self.tableView?.register(cellNib, forCellReuseIdentifier: Constants.cellReuseId)
    }
}

