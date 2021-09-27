//
//  Tasks.swift
//  Chantal
//
//  Created by Monte with Pillow on 9/15/18.
//  Copyright © 2018 Monte Thakkar. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    
    var title: String?
    var url: String?

    private let titleKey = "title"
    private let urlKey = "url"

    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(url, forKey: urlKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObject(forKey: titleKey) as? String,
              let url = aDecoder.decodeObject(forKey: urlKey) as? String
              else { return }
        
        self.title = title
        self.url = url
    }
}
