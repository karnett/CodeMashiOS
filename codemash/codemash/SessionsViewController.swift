//
//  SessionsViewController
//  codemash
//
//  Created by Kim Arnett on 9/18/16.
//  Copyright © 2016 karnett. All rights reserved.
//

import UIKit
import CoreData

enum Day: Int {
    case Tuesday = 1, Wednesday, Thursday, Friday
}

class SessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var filterBtn: UIButton!
    
    //Buttons
    @IBOutlet weak var tuesdayBtn: UIButton!
    @IBOutlet weak var wednesdayBtn: UIButton!
    @IBOutlet weak var thursdayBtn: UIButton!
    @IBOutlet weak var fridayBtn: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var restController = RestController()
    var coreDataController = CoreDataController()
    
    var headerTitle: String = "Tuesday" //Default
    let headerHeight: CGFloat = 45
    
    let detailSegue: String = "showDetails" //Session Details
    
    var viewModel: SessionsViewModel!
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SessionsViewModel(rest: restController, coreData: coreDataController)
        viewModel.checkForOldEntries()
        styleBtns()
        selectedDay(day: viewModel.currentDay)
        
        let radius = self.scrollView.frame.size.height/2

        self.scrollView.layer.cornerRadius = radius
        self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: radius, bottom: 0, right: radius)
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100.0
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(sessionsLoaded), name: NotificationName.sessionsLoaded, object: nil)       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        style()
        
        applyFilter()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.sessionsLoaded, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func sessionsLoaded() {
        self.tableView.reloadData()
    }
    
    func style()
    {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = "Sessions"
        self.tabBarController?.tabBar.tintColor = UIColor.cmTeal()
        self.headerView.backgroundColor = UIColor.cmTeal()
    }
    
    func applyFilter() {
        self.filterBtn.setTitle(viewModel.getFilterButtonText(), for: UIControl.State.normal)
        viewModel.currentDay = viewModel.currentDay
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue {
            let session = viewModel.getSessionAtIndex(row: (selectedIndex?.row)!)
            
            let detail = segue.destination as? SessionDetailsViewController
            detail?.session = session!
            detail?.timeString = getTimeFromString(startDate: session!.startTime, endDate: session!.endTime)
        }
    }
    
    //TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = viewModel.numberOfRowsInSection(section: section)
        self.updateLoading(number: number)
        
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionsCell") as? SessionTableViewCell
        let session = viewModel.getSessionAtIndex(row: indexPath.row)
        if session != nil {
            cell?.titleLabel.text = session!.title ?? ""
            cell?.titleLabel.sizeToFit()
            let rooms: [String] = session?.rooms ?? []
            
            var roomString = ""
            
            
            for index in 0..<rooms.count {
                
                roomString.append(rooms[index])
                
                if index != (rooms.count-1) {
                    roomString.append(", ")
                }
            }
            
            cell?.roomLabel.text = roomString
            cell?.timeLabel.text = getTimeFromString(startDate: session?.startTime, endDate: session?.endTime)
            
            if let id = session?.sessionId {
                cell?.favoriteButton.isSelected = isSessionFavorite(id: Int(id))
            }
            
            if session?.sessionType != "Kidz Mash" {
                cell?.kidzmashIcon.isHidden = true
            } else {
                
                cell?.kidzmashIcon.isHidden = false
            }
            
        }
        cell?.favoriteButton.tag = indexPath.row
        cell?.favoriteButton.addTarget(self, action: #selector(favoriteBtnSelected), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.headerHeight)
        let view = UIView(frame: rect)
        view.backgroundColor = UIColor.cmLime()
        let label = UILabel(frame: rect)
        label.textAlignment = .center
        label.text = self.headerTitle
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor.white
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.performSegue(withIdentifier: detailSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    @IBAction func daySelected(_ sender: UIButton) {
        let tag = sender.tag
        let day = Day.init(rawValue: tag)!
        viewModel.currentDay = day
        selectedDay(day:day)
    }
    
    func selectedDay(day: Day){
        clearBtnBackgrounds()
        switch day {
            case .Tuesday:
                self.tuesdayBtn.layer.borderColor = UIColor.white.cgColor
                self.tuesdayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Tuesday"
                
                viewModel.currentDay = .Tuesday
            
                scrollTableToTop()
            case .Wednesday:
                self.wednesdayBtn.layer.borderColor = UIColor.white.cgColor
                self.wednesdayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Wednesday"
                
                viewModel.currentDay = .Wednesday
                
                scrollTableToTop()
            case .Thursday:
                self.thursdayBtn.layer.borderColor = UIColor.white.cgColor
                self.thursdayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Thursday"
                
                viewModel.currentDay = .Thursday
                
                scrollTableToTop()
            case .Friday:
                self.fridayBtn.layer.borderColor = UIColor.white.cgColor
                self.fridayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Friday"
                
                viewModel.currentDay = .Friday
                
                scrollTableToTop()
        }
        self.tableView.reloadData()
        setSelectedDay(day: day)
    }
    
    func scrollTableToTop() {
        
        if self.tableView.numberOfRows(inSection: 0) > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func clearBtnBackgrounds() {
        self.tuesdayBtn.layer.borderColor = UIColor.clear.cgColor
        self.wednesdayBtn.layer.borderColor = UIColor.clear.cgColor
        self.thursdayBtn.layer.borderColor = UIColor.clear.cgColor
        self.fridayBtn.layer.borderColor = UIColor.clear.cgColor
    }
    
    func styleBtns() {
        self.tuesdayBtn.layer.cornerRadius = 8.0
        self.wednesdayBtn.layer.cornerRadius = 8.0
        self.thursdayBtn.layer.cornerRadius = 8.0
        self.fridayBtn.layer.cornerRadius = 8.0
    }
    
    @objc func favoriteBtnSelected(sender: UIButton) {
        let row = sender.tag
        let session = viewModel.getSessionAtIndex(row: row)
        if let id = session?.sessionId {
            favoriteSession(id: Int(id), isFavorited: sender.isSelected)
            sender.isSelected = !sender.isSelected
        }
    }
    
    @IBAction func filterBtnPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "filterView", sender: self)
    }
    
    func updateLoading(number: Int) {
        let isLoading = self.viewModel.loadingSessions
        if  isLoading {
            //Data is loading
            self.activityIndicator.startAnimating()
            self.loadingLabel.text = "Gathering bits and bytes..."
            self.loadingLabel.isHidden = false
        } else if !isLoading && number == 0 {
            //No data to show
            self.activityIndicator.stopAnimating()
            self.loadingLabel.text = "No sessions to show.\nCheck back closer to the event."
            self.loadingLabel.isHidden = false
        } else {
            self.activityIndicator.stopAnimating()
            self.loadingLabel.isHidden = true
        }
    }
}
