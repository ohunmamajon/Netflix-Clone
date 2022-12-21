//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Okhunjon Mamajonov on 2022/12/22.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        return label
    }()
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "Best Movie Ever"
        return label
    }()
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let webView: WKWebView = {
       let webView  = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(downloadButton)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        configureConstraints()
       
    }
    

     func configureConstraints(){
         let webViewConstraints = [webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                                   webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                   webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                   webView.heightAnchor.constraint(equalToConstant: 300)]
         let titleLableConstraints = [titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20), titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20) ]
         
         let overviewLabelConstraints = [overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
                                         overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                         overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
         
         let downloadButtonConstraints = [downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 25),
                                          downloadButton.widthAnchor.constraint(equalToConstant: 140),
                                          downloadButton.heightAnchor.constraint(equalToConstant: 40)]
         
         NSLayoutConstraint.activate(webViewConstraints)
         NSLayoutConstraint.activate(titleLableConstraints)
         NSLayoutConstraint.activate(overviewLabelConstraints)
         NSLayoutConstraint.activate(downloadButtonConstraints)
    }

    func configure(with model: TitlePreviewViewModel){
        titleLabel.text = model.title
        overViewLabel.text = model.titleOverView
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVide.id.videoId)") else {return}
        webView.load(URLRequest(url: url))
    }
    
}
