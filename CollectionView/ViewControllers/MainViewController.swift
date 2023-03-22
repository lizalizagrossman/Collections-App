//
//  ViewController.swift
//  CollectionView
//
//  Created by Elizabeth on 19/03/2023.
//

import UIKit

enum Link: String {
    case imageURL = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    case courseURL = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    case coursesURL = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    case aboutUsURL = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    case aboutUsURL2 = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
}

enum UserAction: String, CaseIterable  {
    case showImage = "Show Image"
    case fetchCourse = "Fetch Course"
    case fetchCourses = "Fetch Courses"
    case aboutSwiftBook = "About SwiftBook"
    case aboutSwiftBook2 = "About Swift Book 2"
    case showCourses = "Show Courses"
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the results in The Debug area"
        case .failed:
            return "You can see the error in The Debug area"
        }
    }
}

final class MainViewController: UICollectionViewController {
    
    private let userActions = UserAction.allCases
    
    // MARK: UICollectionView Datasource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        cell.userActionLabel.text = userActions[indexPath.item].rawValue
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .showImage: performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchCourse: fetchCourse()
        case .fetchCourses: fetchCourses()
        case .aboutSwiftBook: fetchInfoAboutUs()
        case .aboutSwiftBook2: fetchInfoAboutUsWithEmptyFields()
        case .showCourses: performSegue(withIdentifier: "showCourses", sender: nil)
        }
    }
    
    //MARK: - Navigation

    //MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

    // MARK: UICollectionViewDelegateFlowLayout:
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchCourse() {
        guard let url = URL(string: Link.courseURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let course = try decoder.decode(Course.self, from: data)
                print(course)
                self?.showAlert(withStatus: .success)
            } catch let error {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
            
        }.resume()
    }
    private func fetchCourses() {
        guard let url = URL(string: Link.coursesURL.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let courses = try decoder.decode([Course].self, from: data)
                print(courses)
                self?.showAlert(withStatus: .success)
            } catch let error {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
            
        }.resume()
    }
    
    private func fetchInfoAboutUs() {
        guard let url = URL(string: Link.aboutUsURL.rawValue) else { return }
                
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let sbInfo = try decoder.decode(SwiftBookInfo.self, from: data)
                print(sbInfo)
                self?.showAlert(withStatus: .success)
            } catch let error {
                print(error)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
    
    private func fetchInfoAboutUsWithEmptyFields() {
        guard let url = URL(string: Link.aboutUsURL2.rawValue) else { return }
                
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let sbInfo = try decoder.decode(SwiftBookInfo.self, from: data)
                print(sbInfo)
                self?.showAlert(withStatus: .success)
            } catch let error {
                print(error.localizedDescription)
                self?.showAlert(withStatus: .failed)
            }
        }.resume()
    }
}
