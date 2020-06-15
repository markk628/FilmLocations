//
//  ViewController.swift
//  FilmLocations
//
//  Created by Mark Kim on 6/15/20.
//  Copyright © 2020 Mark Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var films: [FilmEntry] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromFile("locations")
        print(films)
        setFilmTable()
    }
    
    func setFilmTable() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getDataFromFile(_ fileName: String) {
        let path = Bundle.main.path(forResource: fileName, ofType: ".json")
        if let path = path {
            let url = URL(fileURLWithPath: path)
            
            let contents = try? Data(contentsOf: url)
            do {
                if let data = contents,
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] {
                    for film in jsonResult {
                        let firstActor = film["actor_1"] as? String ?? ""
                        let locations = film["locations"] as? String  ?? ""
                        let releaseYear = film["release_year"] as? String  ?? ""
                        let title = film["title"] as? String  ?? ""
                        let movie = FilmEntry(firstActor: firstActor, locations: locations, releaseYear: releaseYear, title: title)
                        films.append(movie)
                    }
                    tableView.reloadData()
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath)
        let film = films[indexPath.row]
        cell.textLabel?.text = film.locations
        return cell
    }
    
    
}

