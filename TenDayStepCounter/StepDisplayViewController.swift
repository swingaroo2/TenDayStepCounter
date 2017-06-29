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
        static let cellNibName   = "StepDisplayTableViewCell"
        static let cellReuseId   = "StepDisplayCell"
        static let detailVCSegue = "showDetailVC"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Note: use simulated data for unsupported devices
        // Check if current device is supported
        
        self.setUpTableView()
        
        self.motionService.getDailyStepDataUntilToday(Constants.numPreviousDays, dispatchGroup: self.dispatchGroup)
        
        if MotionService.needToSimulateData
        {
            self.tableView?.tableFooterView = UIView()
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
        } else {
            self.dispatchGroup.notify(queue: DispatchQueue.main, execute:{ [weak self] in
                self?.tableView?.tableFooterView = UIView()
                self?.tableView?.delegate = self
                self?.tableView?.dataSource = self
                self?.tableView?.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! StepDisplayTableViewCell
        self.performSegue(withIdentifier: Constants.detailVCSegue, sender: cell)
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
        
        if MotionService.needToSimulateData
        {
            let data = self.motionService.simulatedDataArr[indexPath.row]
            cell.configureCellWithSimulatedData(data)
        } else {
            let data = self.motionService.dataArr[indexPath.row]
            cell.configureCellWithData(data)
        }
        return cell
    }
    
    // MARK: – Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == Constants.detailVCSegue
        {
            let cell = sender as! StepDisplayTableViewCell
            let stepData = cell.getStepData()
            let detailVC = segue.destination as! StepDisplayDetailViewController
            detailVC.setPedometerData(stepData)
        }
    }
    
    // MARK: - Helpers
    func setUpTableView()
    {
        let cellNib = UINib(nibName: Constants.cellNibName, bundle: Bundle.main)
        self.tableView?.register(cellNib, forCellReuseIdentifier: Constants.cellReuseId)
        self.setUpRefreshControl()
    }
    
    func setUpRefreshControl()
    {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *)
        {
            self.tableView?.refreshControl = refreshControl
        } else {
            self.tableView?.backgroundView = refreshControl
        }
    }
    
    func refresh(_ refreshControl: UIRefreshControl)
    {
        self.tableView?.reloadData()
        refreshControl.endRefreshing()
    }
}
