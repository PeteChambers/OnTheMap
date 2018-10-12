//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Pete Chambers on 01/03/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
