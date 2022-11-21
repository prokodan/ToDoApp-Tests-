//
//  String +Extensions.swift
//  ToDoApp(Tests)
//
//  Created by Данил Прокопенко on 21.11.2022.
//

import Foundation
///Your own set of allowedCharacters
extension String {

    var percentEncoded: String {
        let allowedCharacters = CharacterSet(charactersIn: "!@#$%^&*()-+=[]\\}{,./<>?").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {fatalError()}
        return encodedString
    }
}
