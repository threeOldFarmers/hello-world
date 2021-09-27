//
//  TasksController.swift
//  Chantal
//
//  Created by Monte with Pillow on 9/15/18.
//  Copyright © 2018 Monte Thakkar. All rights reserved.
//

import UIKit
import WebKit

class TasksController: UITableViewController {
    
    var taskStore: TaskStore! {
        didSet {
            taskStore.tasks = TasksUtility.fetch() ?? [Task]()
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) {_ in
            
            guard let title = alertController.textFields?.first?.text else { return }
            guard let url = alertController.textFields?[1].text else { return }
            
            let newTask = Task(title: title, url: url)
            
            self.taskStore.add(newTask, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            TasksUtility.save(self.taskStore.tasks)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter title..."
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter url..."
        }

        alertController.addAction(addAction);
        alertController.addAction(cancelAction);
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openWebView(task: Task) {
        let webView = WKWebView(frame: self.view.bounds)
        guard let link = URL(string: task.url ?? "") else { return }
        let request = URLRequest(url: link)
        webView.load(request)
        let viewController = UIViewController()
        viewController.view.addSubview(webView)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - DataSource
extension TasksController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.row].title

        return cell
    }
    
}

// MARK: - Delegate
extension TasksController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskStore.tasks[indexPath.row]
        
        openWebView(task: task)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {(action, sourceView, completionHandler) in
            
            self.taskStore.removeTask(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.4901960784, blue: 0.4823529412, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) {(action, sourceView, completionHandler) in
            
            self.showEdit(at: indexPath.row)
            
            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7411764706, blue: 0.6509803922, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
    func showEdit(at index: Int) {
        
        let task = taskStore.tasks[index]
        
        let alertController = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Edit", style: .default) {_ in
            
            guard let title = alertController.textFields?.first?.text else { return }
            guard let url = alertController.textFields?[1].text else { return }
            
            let newTask = Task(title: title, url: url)
            
            self.taskStore.replace(newTask, at: index)
            
            self.tableView.reloadData()
            
            TasksUtility.save(self.taskStore.tasks)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.text = task.title
        }
        
        alertController.addTextField { textField in
            textField.text = task.url
        }

        alertController.addAction(addAction);
        alertController.addAction(cancelAction);
        
        present(alertController, animated: true, completion: nil)
    }
    
}
