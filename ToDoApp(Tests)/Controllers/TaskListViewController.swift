//
//  TaskListViewController.swift
//  ToDoApp(Tests)
//
//  Created by Данил Прокопенко on 11.11.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    
    @IBOutlet var dataProvider: DataProvider!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetail(with:)), name: NSNotification.Name("DidSelectRow notification"), object: nil)
        
        view.accessibilityIdentifier = "mainView"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func showDetail(with notification: Notification) {
        guard let userInfo = notification.userInfo,
        let task = userInfo["task"] as? Task,
              let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { fatalError()}
        detailVC.task = task
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController {
            viewController.taskManager = self.dataProvider.taskManager
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
            
    }
    
}

