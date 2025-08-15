//
//  String+Extension.swift
//  FirstIosApp
//
//  Created by Avantika on 29/03/25.
//

import Foundation


extension String {
    
    func formatPhoneForCall() -> String {
        self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "+", with: "")
    }
}
