//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Okhunjon Mamajonov on 2022/12/15.
//

import Foundation
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
