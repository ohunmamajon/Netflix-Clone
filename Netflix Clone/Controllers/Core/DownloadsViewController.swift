//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Okhunjon Mamajonov on 2022/12/09.
//

import UIKit

class DownloadsViewController: UIViewController {
    private var titles: [TitleItem] = [TitleItem]()
    private let downloadTable: UITableView = {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(downloadTable)
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        downloadTable.delegate = self
        downloadTable.dataSource = self
    fetchCoreData()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchCoreData()
            
        }
    }
    private func fetchCoreData(){
        DataPersistenceManager.shared.fetchingTitlesFromDatabase {[weak self] result in
            switch result{
            case.success(let titles):
                self?.titles = titles
                self?.downloadTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
}
extension DownloadsViewController:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell  else { return UITableViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName:title.original_title ?? title.original_name ?? "no title name", posterURL: title.poster_path ?? "" ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
       
            DataPersistenceManager.shared.deleteTitleWith(model:titles[indexPath.row]) {[weak self] result in
                switch result{
                case.success():
                    print("Deleted the title from Database")
                case.failure(let error):
                    print(error.localizedDescription)
                }
                tableView.beginUpdates()
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .none)
                tableView.endUpdates()
                
            }
       
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titlename = title.original_title ?? title.original_name else {return}
        APICaller.shared.getMovie(with: titlename) { [weak self] result in
            switch result{
                
            case .success(let videElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titlename, youtubeVide: videElement, titleOverView: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

