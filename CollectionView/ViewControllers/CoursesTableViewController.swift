//
//  CoursesTableViewController.swift
//  CollectionView
//
//  Created by Elizabeth on 20/03/2023.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    private var courses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let cell = cell as? CourseCell else { return UITableViewCell() }
        let course = courses[indexPath.row]
        cell.configure(with: course)
        
        return cell
    }

}

// MARK: - Networking
extension CoursesTableViewController {
    func fetchCourses() {
        URLSession.shared.dataTask(with: Link.coursesURL.url) { [weak self]data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                self?.courses = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
