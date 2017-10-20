//
//  SpeakersVeiwController.swift
//  codemash
//
//  Created by Kim Arnett on 10/2/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

class SpeakersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var headerView: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    
    var restController = RestController()
    var coreDataController = CoreDataController()
    
    let detailSegue: String = "showDetails" //Speaker Details
    let headerHeight: CGFloat = 200.0
    
    var viewModel: SpeakersViewModel!
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SpeakersViewModel(rest: restController, coreData: coreDataController)
        
        
        self.viewModel.loadSpeakers()
        self.navigationController?.navigationBar.isHidden = true
        
        self.headerView.backgroundColor = UIColor.cmBlue()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        definesPresentationContext = true
        
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(speakersLoaded), name: NotificationName.speakersLoaded, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: NotificationName.speakersLoaded, object: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func style()
    {
        self.tabBarController?.tabBar.tintColor = UIColor.cmBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.cmBlue()
        self.navigationItem.title = "Speakers"
    }
    
    func speakersLoaded() {
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = viewModel.numberOfRowsInSection(section: section)
        self.updateLoading(number: number)
       
        return  number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "speakersCell") as? SpeakerTableViewCell
        
        let speaker = viewModel.getSpeakerAtIndex(row: indexPath.row)
        
        
        if speaker?.gravatarUrl != nil {
            let url = "https:"+(speaker?.gravatarUrl ?? "")
            cell?.profileImg.af_setImage(withURL: URL(string: url)!)
        }
        
        cell?.nameLabel.text = "\(speaker?.firstName ?? "") \(speaker?.lastName ?? "")"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.performSegue(withIdentifier: detailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue {
            
            let detail = segue.destination as? SpeakerDetailsViewController
            let speaker = self.viewModel.getSpeakerAtIndex(row: self.selectedIndex!.row)
            
            let sessions = self.viewModel.getSessionsForSpeaker(id: (speaker?.speakerId)!)
            detail?.speaker = speaker
            detail?.sessions = sessions
        }
    }
    
    func updateLoading(number: Int) {
        let isLoading = self.viewModel.loadingSpeakers
        if  isLoading {
            //Data is loading
            self.activityIndicator.startAnimating()
            self.loadingLabel.text = "Collecting our minions..."
            self.loadingLabel.isHidden = false
        } else if !isLoading && number == 0 {
            //No data to show
            self.activityIndicator.stopAnimating()
            self.loadingLabel.text = "No speakers to show.\nCheck back closer to the event."
            self.loadingLabel.isHidden = false
        } else {
            self.activityIndicator.stopAnimating()
            self.loadingLabel.isHidden = true
        }
    }
}
