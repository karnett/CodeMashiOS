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
    case Favorites = 0, Tuesday, Wednesday, Thursday, Friday
}

class SessionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Buttons
    @IBOutlet weak var favoritesBtn: UIButton!
    @IBOutlet weak var tuesdayBtn: UIButton!
    @IBOutlet weak var wednesdayBtn: UIButton!
    @IBOutlet weak var thursdayBtn: UIButton!
    @IBOutlet weak var fridayBtn: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var restController = RestController()
    var coreDataController = CoreDataController()
    
    var headerTitle: String = "Favorites" //Default
    let headerHeight: CGFloat = 45
    
    let detailSegue: String = "showDetails" //Session Details
    
    var viewModel: SessionsViewModel!
    var selectedIndex: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel = SessionsViewModel(rest: restController, coreData: coreDataController)
        viewModel.loadSessionsForDay(day: .Favorites)
        
        styleBtns()
        selectedDay(day: Day.Favorites)
        self.scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 70.0

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        style()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(sessionsLoaded), name: NotificationName.sessionsLoaded, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: NotificationName.sessionsLoaded, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sessionsLoaded() {
        self.tableView.reloadData()
    }
    
    func style()
    {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = "Sessions"
        self.tabBarController?.tabBar.tintColor = UIColor.cmTeal()
        self.headerView.backgroundColor = UIColor.cmTeal()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue {
            let session = viewModel.getSessionAtIndex(row: (selectedIndex?.row)!)
            
            var detail = segue.destination as? SessionDetailsViewController
            detail?.session = session!
        }
    }
    
    //TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionsCell") as? SessionTableViewCell
        let session = viewModel.getSessionAtIndex(row: indexPath.row)
        if session != nil {
            cell?.titleLabel.text = session!.title ?? ""
            cell?.titleLabel.sizeToFit()
            cell?.roomLabel.text = session?.rooms ?? "TBD"
            cell?.timeLabel.text = session?.startTime ?? "TBD"
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        self.performSegue(withIdentifier: detailSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
    }
    
    @IBAction func daySelected(_ sender: UIButton) {
        let tag = sender.tag
        selectedDay(day: Day.init(rawValue: tag)!)
    }
    
    func selectedDay(day: Day){
        clearBtnBackgrounds()
        switch day {
            case .Favorites:
                self.favoritesBtn.layer.borderColor = UIColor.white.cgColor
                self.favoritesBtn.layer.borderWidth = 1.0
                self.headerTitle = "Favorites"
                print("Favorites")
            case .Tuesday:
                
                self.tuesdayBtn.layer.borderColor = UIColor.white.cgColor
                self.tuesdayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Tuesday"
                print("Tues")
            case .Wednesday:
                
                self.wednesdayBtn.layer.borderColor = UIColor.white.cgColor
                self.wednesdayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Wednesday"
                print("Wed")
            case .Thursday:
                
                self.thursdayBtn.layer.borderColor = UIColor.white.cgColor
                self.thursdayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Thursday"
                print("Thurs")
            case .Friday:
                
                self.fridayBtn.layer.borderColor = UIColor.white.cgColor
                self.fridayBtn.layer.borderWidth = 1.0
                self.headerTitle = "Friday"
                print("Friday")
        }
        self.tableView.reloadData()
    }
    
    func clearBtnBackgrounds() {
        self.favoritesBtn.layer.borderColor = UIColor.clear.cgColor
        self.tuesdayBtn.layer.borderColor = UIColor.clear.cgColor
        self.wednesdayBtn.layer.borderColor = UIColor.clear.cgColor
        self.thursdayBtn.layer.borderColor = UIColor.clear.cgColor
        self.fridayBtn.layer.borderColor = UIColor.clear.cgColor
    }
    
    func styleBtns() {
        self.favoritesBtn.layer.cornerRadius = 8.0
        self.tuesdayBtn.layer.cornerRadius = 8.0
        self.wednesdayBtn.layer.cornerRadius = 8.0
        self.thursdayBtn.layer.cornerRadius = 8.0
        self.fridayBtn.layer.cornerRadius = 8.0
    }
    


}

